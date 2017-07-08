#ifndef THERMYTE_SCRIPT_APP_H
#define THERMYTE_SCRIPT_APP_H

struct ScriptApp;
typedef struct ScriptApp ScriptApp;

ScriptApp* scriptAppNew(const char* filename, void* nano_vg);
void scriptAppDelete(ScriptApp* app);

void scriptAppInit(ScriptApp* app);
void scriptAppUpdate(ScriptApp* app, double t);
void scriptAppDraw(ScriptApp* app);

#endif /* THERMYTE_SCRIPT_APP_H */
