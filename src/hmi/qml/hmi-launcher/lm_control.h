
#ifndef LM_CONTROL_H
#define LM_CONTROL_H

#include <stdio.h>
#include <QObject>

#define DEBUG_LEVEL 0

#define LOG_INFO(...) { \
	if (0 < DEBUG_LEVEL) { \
		printf("[INFO] " __VA_ARGS__); \
	} \
}

#define LOG_WARNING(...) { \
	if (1 < DEBUG_LEVEL) { \
		printf("[WARNING] " __VA_ARGS__); \
	} \
}

#define LOG_ERROR(...) { \
	if (1 < DEBUG_LEVEL) { \
		printf("[ERROR] " __VA_ARGS__); \
	} \
}

class lm_control : QObject
{
	Q_OBJECT

	public:
		lm_control(QObject *parent = 0);
		~lm_control();

		Q_INVOKABLE void surface_set_visibility(int surfaceid, int visibility);
		Q_INVOKABLE void surface_set_source_rectangle(
			int surfaceid, int x, int y, int width, int height);
		Q_INVOKABLE void surface_set_destination_rectangle(
			int surfaceid, int x, int y, int width, int height);
		Q_INVOKABLE void commit_changes();
};

#endif // LM_CONTROL_H
