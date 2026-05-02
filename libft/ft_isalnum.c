
#include "libft.h"

int	ft_isalnum(int c)
{
	if ((c >= 65 && c <= 90) || (c >= 97 && c <= 122) || (c >= 48 && c <= 57))
		return (1);
	return (0);
}

// int	main()
// {
// 	char tst[]={' '};
// 	int i = 0;
// 	int c = ft_isalnum(tst[i]);
// 	printf("%d",c);

// }