/*
 * Simple ncurses form example with fields that actually behaves like fields.
 *
 * How to run:
 *	gcc -Wall -Werror -g -pedantic -o boxes boxes.c -lncurses
 */
#include <ncurses.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

static WINDOW *win_body;//, *nwin;

#if 0
/*
 * This is useful because ncurses fill fields blanks with spaces.
 */
static char* trim_whitespaces(char *str)
{
	char *end;

	// trim leading space
	while(isspace(*str))
		str++;

	if(*str == 0) // all spaces?
		return str;

	// trim trailing space
	end = str + strnlen(str, 128) - 1;

	while(end > str && isspace(*end))
		end--;

	// write new null terminator
	*(end+1) = '\0';

	return str;
}
#endif

static void box_driver(int ch)
{
	switch (ch) {
		case KEY_F(2):
			break;

		case KEY_DOWN:
			break;

		case KEY_UP:
			break;

		case KEY_LEFT:
			break;

		case KEY_RIGHT:
			break;

		default:
			break;
	}

}

int main()
{
	int ch;

	initscr();
	noecho();
	cbreak();
	keypad(stdscr, TRUE);

	win_body = newwin(24, 80, 0, 0);
	assert(win_body != NULL);
	box(win_body, 0, 0);
	mvwprintw(win_body, 1, 2, "Press F2 to quit ");
	

	refresh();
	wrefresh(win_body);

	while ((ch = getch()) != KEY_F(1))
		box_driver(ch);

	delwin(win_body);
	endwin();

	return 0;
}
