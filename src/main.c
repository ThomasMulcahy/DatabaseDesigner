#include "platform.h"
#include "view.h"

#include <stdio.h>
#include <stdlib.h>

#include "database.h"

void onCreate(ViewData* data) {
    View *view = malloc(sizeof(View));
    Database *db = getData(data, "db");
    db = malloc(sizeof(Database));
    db->tables = NULL;

    addData(data, "db", db);
}

void onViewEvent(ViewData *data, ViewEvent event) {
     switch (event.eventKind) {
        case KEY_DOWN_EVENT:

            break;
        case MOUSE_UP_EVENT:{
                Table *table = createTable(event.mouseX, event.mouseY, "Test");

                Database *db = (Database *) getData(data, "db");
                if (db != NULL) {
                    table->nextTable = db->tables;
                    db->tables = table;
                }
            }
            break;
    }
}

void onViewDestroy(ViewData *data) {

}

int main() {

    WindowOpt options = {
        .title = "DBDesigner",
        .width = 640,
        .height = 400
    };

    ViewData *data = malloc(sizeof(ViewData));
    data->values = NULL;

    View view = {
        .data = data,

        .onCreate = onCreate,
        .onViewEvent = onViewEvent,
        .onViewDestroy = onViewDestroy
    };

    return platformRun(&options, &view);
}