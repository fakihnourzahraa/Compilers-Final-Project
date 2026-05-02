
# include "syntax_analysis.h"

void	add_cmd(t_shell *shell, t_cmd *cmd)
{
	t_cmd	*cur;

	if (!shell->cmds)
		shell->cmds = cmd;
	else
	{
		cur = shell->cmds;
		while (cur->next)
			cur = cur->next;
		cur->next = cmd;
	}
}

t_cmd	*init_cmd(t_token *t)
{
	int		wc;
	int		i;
	t_cmd	*cmd;

	wc = word_count_p(t);
	cmd = malloc(sizeof(t_cmd));
	cmd->args = malloc(sizeof(char *) * (wc + 1));
	cmd->space = malloc(sizeof(int) * (wc + 1));
	cmd->path = NULL;
	cmd->rd = NULL;
	cmd->i_fd = STDIN_FILENO;
	cmd->o_fd = STDOUT_FILENO;
	cmd->pid = -1;
	cmd->builtin = NOT_BUILTIN;
	cmd->next = NULL;
	cmd->cmd = NULL;
	i = 1;
	while (i < (wc + 1))
	{
		cmd->args[i] = NULL;
		cmd->space[i] = 1;
		i++;
	}
	return (cmd);
}
