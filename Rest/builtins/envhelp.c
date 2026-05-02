
#include "builtin.h"

void	update_shlvl_on_start(t_shell *shell)
{
	t_env	*shlvl;
	int		lvl;
	char	*new_shlvl;

	shlvl = find_env_var(shell->env, "SHLVL");
	if (shlvl && shlvl->val)
		lvl = ft_atoi(shlvl->val) + 1;
	else
		lvl = 1;
	new_shlvl = ft_itoa(lvl);
	if (!new_shlvl)
		return ;
	set_env_var(&shell->env, "SHLVL", new_shlvl, true);
	free(new_shlvl);
}

void	update_shlvl_on_exit(t_shell *shell)
{
	t_env	*shlvl;
	int		lvl;
	char	*new_shlvl;

	shlvl = find_env_var(shell->env, "SHLVL");
	if (!shlvl)
		return ;
	lvl = ft_atoi(shlvl->val);
	if (lvl > 1)
		lvl--;
	else
		lvl = 0;
	new_shlvl = ft_itoa(lvl);
	if (!new_shlvl)
		return ;
	set_env_var(&shell->env, "SHLVL", new_shlvl, true);
	free(new_shlvl);
}
