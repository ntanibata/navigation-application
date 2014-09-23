
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include "lm_control.h"
#include "ilm_client.h"
#include "ilm_control.h"
#include "ilm_common.h"

t_ilm_layer application;
t_ilm_layer navit;

lm_control::lm_control(QObject *parent)
{
	(void)parent;
	ilm_init();
	return;
}

lm_control::~lm_control()
{
	ilm_destroy();
}

void
lm_control::surface_set_visibility(int surfaceid, int visibility)
{
	t_ilm_surface surface_id     = 0;
	t_ilm_bool    ilm_visibility = 0;

	LOG_INFO("lm_control::surface_set_visibility"
		"(surfaceid=%d, visibility=%d)\n"
		,surfaceid ,visibility);

	surface_id     = (t_ilm_surface)surfaceid;
	ilm_visibility = (t_ilm_bool)visibility;

	ilmErrorTypes ret = ilm_surfaceSetVisibility(surface_id, ilm_visibility);

	if (ILM_SUCCESS != ret)
	{
		LOG_WARNING("failed to layer_set_visibility.\n");
	}
}

void
lm_control::surface_set_source_rectangle(
	int surfaceid, int x, int y, int width, int height)
{
	t_ilm_surface surface_id  = 0;
	t_ilm_int    ilm_x       = 0;
	t_ilm_int    ilm_y       = 0;
	t_ilm_int    ilm_width   = 0;
	t_ilm_int    ilm_height  = 0;

	LOG_INFO("lm_control::surface_set_source_rectangle"
		"(surfaceid=%d, x=%d, y=%d, width=%d, height=%d)\n"
		,surfaceid ,x ,y ,width ,height);

	surface_id = (t_ilm_surface)surfaceid;
	ilm_x      = (t_ilm_int)x;
	ilm_y      = (t_ilm_int)y;
	ilm_width  = (t_ilm_int)width;
	ilm_height = (t_ilm_int)height;

	ilmErrorTypes ret = ilm_surfaceSetSourceRectangle(
		surface_id, ilm_x, ilm_y, ilm_width, ilm_height);

	if (ILM_SUCCESS != ret)
	{
		LOG_WARNING("failed to surface_set_source_rectangle.\n");
	}
}

void
lm_control::surface_set_destination_rectangle(
	int surfaceid, int x, int y, int width, int height)
{
	t_ilm_surface surface_id  = 0;
	t_ilm_int    ilm_x       = 0;
	t_ilm_int    ilm_y       = 0;
	t_ilm_int    ilm_width   = 0;
	t_ilm_int    ilm_height  = 0;

	LOG_INFO("lm_control::surface_set_destination_rectangle"
		"(surfaceid=%d, x=%d, y=%d, width=%d, height=%d)\n"
		,surfaceid ,x ,y ,width ,height);

	surface_id = (t_ilm_surface)surfaceid;
	ilm_x      = (t_ilm_int)x;
	ilm_y      = (t_ilm_int)y;
	ilm_width  = (t_ilm_int)width;
	ilm_height = (t_ilm_int)height;

	ilmErrorTypes ret = ilm_surfaceSetDestinationRectangle(
		surface_id, ilm_x, ilm_y, ilm_width, ilm_height);

	if (ILM_SUCCESS != ret)
	{
		LOG_WARNING("failed to surface_set_destination_rectangle.\n");
	}
}

void
lm_control::commit_changes()
{
	LOG_INFO("lm_control::commit_changes()\n");

	ilmErrorTypes ret = ilm_commitChanges();
	if (ILM_SUCCESS != ret)
	{
		LOG_WARNING("failed to comit_changes.\n");
	}
}
