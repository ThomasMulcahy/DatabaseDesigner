#include "database.h"
#include <stdlib.h>

Table *createTable(int xPos, int yPos, char *tableName) {
    Table *result = malloc(sizeof(Table));
    result->width = 150;
    result->height = 75;
    result->xPos = xPos;
    result->yPos = yPos - result->height;
    result->tableName = tableName;

    result->isSelected = 1;

    return result;
}

void addRow(Table *table, char *name, enum DataType type) {
    TableRow *row = malloc(sizeof(TableRow));
    row->rowName = name;
    row->type = type;

    row->nextRow = table->rows;
    table->rows = row;
}

void deleteTable(Table table) {

}