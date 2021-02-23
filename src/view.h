#ifndef VIEW_H
#define VIEW_H

#include "database.h"

#define KEY_H_CODE 0x68
#define KEY_J_CODE 0x6a
#define KEY_K_CODE 0x6b
#define KEY_L_CODE 0x6c

typedef enum _ViewEventKind {
    KEY_DOWN_EVENT,
    MOUSE_UP_EVENT
} ViewEventKind;

typedef struct _ViewEvent {
    ViewEventKind eventKind;

    //Keydown Event
    char code;

    //Mouse related events
    int mouseX;
    int mouseY;
} ViewEvent;

typedef struct _View {
    Database* db;
} View;

View* onViewCreate();

void onViewEvent(View *view, ViewEvent event);

void viewDestroy(View *view);

#endif
