# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: allefebv <allefebv@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/05/30 13:41:26 by mnishimo          #+#    #+#              #
#    Updated: 2019/06/26 14:18:11 by sunakim          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

VM_NAME		= corewar
ASM_NAME	= asm
LIBFT		= libftprintf.a
OBJ_DIR		= obj

CC = gcc -g
CFLAGS = -Wall -Werror -Wextra
#CFLAGS = -Wall -Werror -Wextra -g -fsanitize=address
#CFLAGS = -fsanitize=address

RM = rm -rf
LDIR = -L libftprintf/ -lftprintf
INCLUDES = -I includes/  -I libftprintf/includes

HEADER =  $(addprefix includes/, corewar.h op.h)

VM_SRC = $(addprefix src/vm/, main.c init_corewar.c process.c instructions.c \
		 decode.c ocp.c free.c lst_util.c util.c)
VM_INST_SRC = $(addprefix src/vm/instructions/, inst01_live.c inst02_ld.c \
		inst03_st.c inst04_add.c inst05_sub.c inst06_and.c inst07_or.c \
		inst08_xor.c inst09_zjmp.c inst0a_ldi.c inst0b_sti.c inst0c_fork.c \
		inst0d_lld.c inst0e_lldi.c inst0f_lfork.c inst10_aff.c)

VM_OBJ = $(VM_SRC:src/vm/%.c=obj/%.o)
VM_INST_OBJ = $(VM_INST_SRC:src/vm/instruction/%.c=obj/%.o)

ASM_SRC =	$(addprefix src/asm/, asm_main.c finished_state_machines.c			\
			read_asm.c ft_memrev.c ft_isspace.c ft_memjoin.c ocp_management.c	\
			ft_atochar.c ft_atolong.c ft_atos.c utils.c bytecode_management.c	\
			tkn_create_1.c tkn_create_2.c tkn_create_3.c tkn_create_4.c			\
			end_functions.c	initializations.c free_fncs.c tkn_creations.c		\
			lexical_analysis.c syntactic_analysis.c error.c error_types.c		\
			error_display.c)

ASM_OBJ	=	$(ASM_SRC:src/asm/%.c=obj/%.o)

SRC		=	src/op.c

OBJ		=	$(SRC:src/%.c=obj/%.o)

.PHONY: all fclean clean re

all: $(VM_NAME) $(ASM_NAME)

$(OBJ_DIR):
	mkdir $(OBJ_DIR)

$(LIBFT):
	make -C libftprintf/

obj/%.o: src/vm/%.c $(HEADER)
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<

obj/%.o: src/asm/%.c $(HEADER) $(OBJ_DIR)
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<

obj/%.o: src/%.c $(HEADER) $(OBJ_DIR)
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<

$(VM_NAME): $(LIBFT) $(VM_OBJ) $(VM_INST_OBJ)
	$(CC) $(CFLAGS)  -o $(VM_NAME) $(VM_OBJ) $(VM_INST_OBJ) $(LDIR) $(INCLUDES)

$(ASM_NAME):  $(LIBFT) $(ASM_OBJ) $(OBJ)
	$(CC) $(CFLAGS)  -o $(ASM_NAME) $(ASM_OBJ) $(OBJ) $(LDIR) $(INCLUDES)

clean:
	$(RM) $(VM_OBJ) $(ASM_OBJ)
	$(RM) $(OBJ_DIR)
	make -C libftprintf/ clean

fclean: clean
	$(RM) $(VM_NAME) $(ASM_NAME)
	make -C libftprintf/ fclean

re: fclean all
