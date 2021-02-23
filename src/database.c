#include "database.h"
#include <stdlib.h>

Table *createTable(int xPos, int yPos, char *tableName) {
    Table *result = malloc(sizeof(Table));
    result->width = 150;
    result->height = 75;
    result->xPos = xPos;
    result->yPos = yPos - result->height;
    result->tableName = tableName;

    return result;
}

void deleteTable(Table table) {

}