# DigitalSign

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 6.0.8.

## Development server

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The app will automatically reload if you change any of the source files.

## Code scaffolding

Run `ng generate component component-name` to generate a new component. You can also use `ng generate directive|pipe|service|class|guard|interface|enum|module`.

## Build

Run `ng build` to build the project. The build artifacts will be stored in the `dist/` directory. Use the `--prod` flag for a production build.

## Running unit tests

Run `ng test` to execute the unit tests via [Karma](https://karma-runner.github.io).

## Running end-to-end tests

Run `ng e2e` to execute the end-to-end tests via [Protractor](http://www.protractortest.org/).

## Further help

To get more help on the Angular CLI use `ng help` or go check out the [Angular CLI README](https://github.com/angular/angular-cli/blob/master/README.md).

# Serverless deployment (Ask Jordan if you want a deployment done)

This article serves as a reference to these instructions (https://medium.com/@maciejtreder/angular-serverless-a713e86ea07a)



`ng add @ng-toolkit/serverless —-provider aws` Gets the scripts for deploying to aws using serverless.io.

`npm run build:serverless:deploy` Builds the deployment package and deploys it (This uses cloudformation, so reference that to see what was actually created)

Next add the Twitter endpoint to the API Gateway and update the .env credentials for it
