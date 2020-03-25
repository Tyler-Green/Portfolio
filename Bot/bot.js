// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

//should possible create some sort of user to handle each request
const { ActivityHandler, MemoryStorage } = require('botbuilder');
var path = require('path')
const { CosmosDbPartitionedStorage } = require("botbuilder-azure");
const restify = require('restify');

//var storage = new MemoryStorage();

const ENV_FILE = path.join(__dirname, '.env');
require('dotenv').config({ path: ENV_FILE });

var storage = new CosmosDbPartitionedStorage({
    cosmosDbEndpoint: process.env.DB_SERVICE_ENDPOINT,
    authKey: process.env.AUTH_KEY,
    databaseId: process.env.DATABASE_ID,
    containerId: process.env.CONTAINER
})

class User {
    constructor() {
        this.Service_List = ["taxi", "food delivery", "home care", "cleaning"];
        this.state = 0;
    }
    stateHandler(input) {
        var resp = "";
        switch(this.state) {
            case 0: //fname
                resp = "What Is Your Last Name?";
                break;
            case 1: //lname
                resp = "What Is Your Address?";
                break;
            case 2: //address
                resp = "What Is Your City?";
                break;
            case 3: //city
                resp = "What Is Your Email?";
                break;
            case 4: //email
                resp = "What Is Your Phone Number?";
                break;
            case 5: //phone
                resp = "What Is The Date?";
                break;
            case 6: //Date
                resp = "What Is The Time?";
                break;
            case 7: //time
                resp = "What Service Is Required?";
                break;
            case 8: //services
                resp = "Your Request Is Being Processed.";
                if (this.Service_List.includes(input) == false) {
                        resp = "What Service Is Required?";
                        this.state--;
                }
                break;
            default: //Request Proccessed
                resp = "Your Request Is Being Processed.";
                break;
        }
        this.state++;
        return resp;
    }
    verifyState(input) {
        if (this.state == 8 && this.Service_List.includes(input) == false) return false;
        return this.state < 10;
    }
}
class Botty extends ActivityHandler {
    constructor() {
        super();
        this.users = {};
        // See https://aka.ms/about-bot-activity-message to learn more about the message and other activity types.
        this.onMessage(async (context, next) => {
            //console.log(context);
            var indiv = this.users[context.activity.from.id];
            if (indiv != null) {
                var resp = indiv.stateHandler(context.activity.text);
                await context.sendActivity(`${ resp }`);
                if (indiv.verifyState(context.activity.text)) await logMessageText(storage, context);
            }
            //indiv.verifyState(context);
            // By calling next() you ensure that the next BotHandler is run.
            await next();
        });

        this.onMembersAdded(async (context, next) => {
            const membersAdded = context.activity.membersAdded;
            for (let cnt = 0; cnt < membersAdded.length; ++cnt) {
                if (membersAdded[cnt].id !== context.activity.recipient.id) {
                    this.users[context.activity.from.id] = new User();
                    await context.sendActivity('Hello and Im Botty_McBot!');
                    await context.sendActivity('What is your First Name?');
                }
            }
            // By calling next() you ensure that the next BotHandler is run.
            await next();
        });
    }
}
// This function stores new user messages. Creates new utterance log if none exists.
async function logMessageText(storage, context) {
    let utterance = context.activity.text;
    var id = context.activity.from.id;
    // debugger;
    try {
        // Read from the storage.
        let storeItems = await storage.read([id])
        // Check the result.
        var Log = storeItems[id];
        if (typeof (Log) != 'undefined') {
            // The log exists so we can write to it.
            storeItems[id].data.push(utterance);
            // Gather info for user message.
            var storedString = storeItems[id].data.toString();

            try {
                await storage.write(storeItems)
                //await context.sendActivity(`The list is now: ${storedString}`);
            } catch (err) {
                await context.sendActivity(`Write failed of ${id}: ${err}`);
            }
        }
        else{
            //await context.sendActivity(`Creating and saving new utterance log`);
            storeItems[id] = { data: [`${utterance}`], "eTag": "*"}
            // Gather info for user message.
            var storedString = storeItems[id].data.toString();

            try {
                await storage.write(storeItems)
                //await context.sendActivity(`The list is now: ${storedString}`);
            } catch (err) {
                await context.sendActivity(`Write failed: ${err}`);
            }
        }
    }
    catch (err){
        await context.sendActivity(`Read rejected. ${err}`);
    }
}
module.exports.Botty = Botty;
