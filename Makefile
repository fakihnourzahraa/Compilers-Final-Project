
NAME = minishell
CC = cc
CFLAGS = -Wall -Wextra -Werror

LIBFT_DIR = libft
LIBFT = $(LIBFT_DIR)/libft.a

SRCS = main/main.c \
       main/signal.c \
       main/processing.c \
       builtins/echo.c \
       builtins/pwd.c \
       builtins/exit.c \
       builtins/cd.c \
       builtins/env.c \
       builtins/envhelp.c \
       builtins/export.c \
       builtins/unset.c \
       builtins/builutils.c \
       Semantic_Analysis/exec/exec_built.c \
       Semantic_Analysis/exec/buitl.c \
       Semantic_Analysis/exec/execute_single.c \
       Semantic_Analysis/exec/execute_path.c \
       Semantic_Analysis/exec/utilsexec.c \
       Semantic_Analysis/exec/redirection.c \
       Semantic_Analysis/exec/clean.c \
       Semantic_Analysis/exec/redir_utils.c \
       Semantic_Analysis/exec/heredoc.c \
       Semantic_Analysis/exec/heredoc_util.c \
       Semantic_Analysis/exec/heredoc_util2.c \
       Semantic_Analysis/exec/redirecttion_utils.c \
       Semantic_Analysis/exec/exec_single_help.c \
       Semantic_Analysis/exec/exec_single_help2.c \
       Semantic_Analysis/exec/multcmnd.c \
       Semantic_Analysis/exec/pipeline.c \
       Semantic_Analysis/exec/pipeline2.c \
       Semantic_Analysis/exec/utils2exec.c \
       Semantic_Analysis/exec/pipeutils.c \
       Semantic_Analysis/exec/exec_pip.c \
       Semantic_Analysis/exec/input_redr.c \
       Semantic_Analysis/exec/output_redr.c \
       env/envir.c \
       env/envir2.c \
       env/envir3.c \
       env/envir.utils.c \
       Semantic_Analysis/expansion/expansion.c \
       Semantic_Analysis/expansion/expand_var.c \
       Semantic_Analysis/expansion/trim.c \
       Semantic_Analysis/expansion/replace_var.c \
       Lexical_Analysis/data_structure.c \
       Lexical_Analysis/edge.c \
       Syntax_Analysis/parsing.c \
       Syntax_Analysis/redir.c \
       Syntax_Analysis/cmds.c \
       Lexical_Analysis/splits.c \
       Lexical_Analysis/chars.c \
       Lexical_Analysis/token_helpers.c \
       Lexical_Analysis/token.c \
       cleanup.c \
       Semantic_Analysis/expansion/split_help.c\
       Semantic_Analysis/expansion/segments.c\
       cleanup_two.c

OBJS = $(SRCS:.c=.o)

all: $(NAME)

$(LIBFT):
	make -C $(LIBFT_DIR)

$(NAME): $(LIBFT) $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -L$(LIBFT_DIR) -lft -lreadline -o $(NAME)

%.o: %.c
	$(CC) $(CFLAGS) -I$(LIBFT_DIR) -c $< -o $@

clean:
	rm -f $(OBJS)
	make -C $(LIBFT_DIR) clean

fclean: clean
	rm -f $(NAME)
	make -C $(LIBFT_DIR) fclean

re: fclean all

.PHONY: all clean fclean re