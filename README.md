# CAP Attachments Plugin - README

## Introduction
The **CAP Attachments Plugin** allows seamless integration of file attachments into SAP BTP CAP applications. This repository demonstrates how to set up and use the `@cap-js/attachments` plugin to enable attachments for the `Books` entity in a Fiori List Report application.

## Project Structure
```
cap-attachments
├── README.md
├── app
│   ├── books
│   │   ├── README.md
│   │   ├── annotations.cds
│   │   ├── package-lock.json
│   │   ├── package.json
│   │   ├── ui5-deploy.yaml
│   │   ├── ui5.yaml
│   │   ├── webapp
│   │   │   ├── Component.js
│   │   │   ├── i18n
│   │   │   │   ├── i18n.properties
│   │   │   ├── index.html
│   │   │   ├── manifest.json
│   │   │   ├── test
│   │   │   │   ├── flpSandbox.html
│   │   │   │   ├── integration
│   │   │   │   │   ├── FirstJourney.js
│   │   │   │   │   ├── opaTests.qunit.html
│   │   │   │   │   ├── opaTests.qunit.js
│   │   │   │   │   ├── pages
│   │   │   │   │   │   ├── BooksList.js
│   │   │   │   │   │   ├── BooksObjectPage.js
│   ├── xs-app.json
│   ├── services.cds
├── db
│   ├── data
│   │   ├── my.bookshop-Books.csv
│   ├── schema.cds
│   ├── src
│   ├── undeploy.json
├── db.sqlite
├── eslint.config.mjs
├── mta.yaml
├── package-lock.json
├── package.json
├── srv
│   ├── cat-service.cds
├── xs-security.json
```

## Steps to Enable Attachments

### 1. Install the Attachments Plugin
To enable attachments, install the `@cap-js/attachments` package:
```sh
npm add @cap-js/attachments
```

### 2. Define Attachment Association in the Database Model
Modify `db/schema.cds` to include the `Attachments` entity from `@cap-js/attachments` and create a composition relation to `Books`:

```cds
namespace my.bookshop;

using { Attachments } from '@cap-js/attachments';

entity Books {
  key ID    : Integer;
      title : String;
      stock : Integer;
      Book  : Composition of many Attachments;
}
```

This allows multiple attachments to be associated with each book entry.

### 3. Define Attachments in the Service Layer
Modify `srv/cat-service.cds` to expose the `Books` entity with attachments in `CatalogService`:

```cds
using my.bookshop as my from '../db/schema';

service CatalogService {
    @odata.draft.enabled
    entity Books as projection on my.Books;
}
```

### 4. Configure Fiori List Report to Display Attachments
The front-end application is built as a Fiori List Report App under `app/books`. Modify `app/books/annotations.cds` to define UI annotations for displaying book information:

```cds
using CatalogService as service from '../../srv/cat-service';

annotate service.Books with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'ID',
                Value : ID,
            },
            {
                $Type : 'UI.DataField',
                Label : 'title',
                Value : title,
            },
            {
                $Type : 'UI.DataField',
                Label : 'stock',
                Value : stock,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'ID',
            Value : ID,
        },
        {
            $Type : 'UI.DataField',
            Label : 'title',
            Value : title,
        },
        {
            $Type : 'UI.DataField',
            Label : 'stock',
            Value : stock,
        },
    ],
);
```

## Functionality Handled by the Plugin
The `@cap-js/attachments` plugin automates the following:
- **File Upload Handling**: Users can upload files and associate them with an entity.
- **Metadata Management**: File information is stored in the database.
- **Secure Storage**: CAP handles attachment storage and retrieval securely.
- **OData Integration**: The plugin integrates with OData services for seamless file access.

## Running the Application
To test the application locally, follow these steps:

1. **Start the CAP Backend Service:**
   ```sh
   cds watch
   ```

2. **Deploy the UI5 Application:**
   ```sh
   cd app/books
   npm install
   npm start
   ```

3. **Open the Application in a Browser:**
   Navigate to `http://localhost:4004` and access the `Books` entity.

## Conclusion
This guide provides a step-by-step approach to integrating the `@cap-js/attachments` plugin into an SAP CAP application. The plugin simplifies file management, allowing users to attach documents to CAP entities efficiently. With the provided setup, your CAP application is now capable of handling attachments seamlessly.

