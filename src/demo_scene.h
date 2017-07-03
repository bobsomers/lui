#ifndef THERMYTE_DEMO_SCENE_H
#define THERMYTE_DEMO_SCENE_H

struct DemoScene;
typedef struct DemoScene DemoScene;

DemoScene* demoSceneNew();
void demoSceneDraw(DemoScene* scene, float aspect_ratio);
void demoSceneDelete(DemoScene* scene);

#endif /* THERMYTE_DEMO_SCENE_H */
