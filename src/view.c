#include "view.h"
#include "database.h"
#include <stdlib.h>
#include <stdio.h>

View* onViewCreate() {
    View *view = malloc(sizeof(View));
    view->db = malloc(sizeof(Database));
    view->db->tables = NULL;
    return view;
}

void onViewEvent(View *view, ViewEvent event) {
    switch (event.eventKind) {
        case KEY_DOWN_EVENT:

            break;
        case MOUSE_UP_EVENT:{
                Table *table = createTable(event.mouseX, event.mouseY, "Test");

                Database *db = view->db;
                table->nextTable = db->tables;
                db->tables = table;
            }
            break;
    }
}

void viewDestroy(View *view) {

}
