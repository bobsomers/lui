#ifndef THERMYTE_SCRIPT_APP_H
#define THERMYTE_SCRIPT_APP_H

struct ScriptApp;
typedef struct ScriptApp ScriptApp;

ScriptApp* scriptAppNew();
void scriptAppDelete(ScriptApp* app);

void scriptAppInit(ScriptApp* app);
void scriptAppUpdate(ScriptApp* app, double t);
void scriptAppDraw(ScriptApp* app, void* vg);

#endif /* THERMYTE_SCRIPT_APP_H */
