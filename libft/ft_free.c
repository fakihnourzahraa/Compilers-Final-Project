
#include "libft.h"

void	free_all(char **words, int i)
{
	while (i--)
		free(words[i]);
	free(words);
}
