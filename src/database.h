#ifndef DATABASE_H
#define DATABASE_H

enum DataType {
    CHAR,
    VARCHAR,
    BINARY,
    VARBINARY,

    BIT,
    BOOLEAN,
    INT,
    FLOAT,
    DOUBLE,
    DECIMAL,

    DATE,
    DATETIME,
    TIMESTAMP,
    TIME,
    YEAR
};

typedef struct _TableRow {
    char *rowName;
    enum DataType type;

    //Linked list
    struct _TableRow *nextRow;
} TableRow;

typedef struct _Table {
    char *tableName;

    //LinkedList
    TableRow *rows;

    //Location for rendering
    int xPos;
    int yPos;
    int height;
    int width;

    //LinkedList
    struct _Table *nextTable;
} Table;

//Main struct for definging a database
typedef struct _Database {
    char *databaseName;

    //LinkedList
    Table *tables;
} Database;

/*
 * Creates a table at a desired location.
 */
Table *createTable(int xPos, int yPos, char *tableName);

void deleteTable(Table table);

#endif