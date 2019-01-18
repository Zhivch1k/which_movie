#!/bin/bash

#######################################################
#       Функция для считывания верной директории      #
read_path () {
	printf "Введите путь: "
	read FILMS_PATH; echo $FILMS_PATH > films_path
	until [ -d "$FILMS_PATH" ]; do
		printf "Кажется, это не директория, либо здесь нет папок с кино.\n"
		printf "Пожалуйста укажите полный путь\n\n"
		read FILMS_PATH; echo $FILMS_PATH > films_path
	done
	printf "Путь успешно записан!\n"
}
########################################################

########################################################
#      Функция получения количества файлов             #
get_amount_of_files () {
	AMOUNT_OF_FILES=$(ls -f $FILMS_PATH | wc -l)
	while [ $AMOUNT_OF_FILES -le 2 ]; do
		printf "В указанной директорие нет фильмов :(\n"
		read_path
		AMOUNT_OF_FILES=$(ls -f $FILMS_PATH | wc -l)
	done
	let "AMOUNT_OF_FILES -= 2"
}
########################################################

########################################################
# Функция нахождения случайного числа исходя из        #
#              количества файлов                       #
random_number_in_dir () {
	NUMBER=$RANDOM
	while [ $NUMBER -gt $AMOUNT_OF_FILES ]; do
		NUMBER=$RANDOM
		let "NUMBER = NUMBER % $AMOUNT_OF_FILES + 1"
	done
}
########################################################

########################################################
#             Открываем искомый файл                   #
open_random_file () {
	i=1
	for FILE_NAME in $FILMS_PATH/*; do
		#Когда мы нашли случайный файл или директорию
		#Проверяем что это
		if [ $NUMBER -eq $i ]; then
			if [ -f $FILE_NAME ]; then
				printf "Приятного просмотра!\n"
				xdg-open $FILE_NAME
			elif [ -d $FILE_NAME ]; then
				FILMS_PATH=$FILE_NAME
				get_amount_of_files
				random_number_in_dir
				open_random_file
			fi
		fi
		let "i += 1"
	done
}
########################################################
clear
if [ ! -f films_path ]; then
	printf "\033[35;1mПриветствую!\033[0m\n"
	printf "\033[36;1mЭтот скрипт написан для того, чтобы включать\n"
	printf "Рандомную серию вашего любимого сериала\n"
	printf "Или просто рандомный фильм:)\033[0m\n\n"
	printf "\033[34;1mВ текущей директории будет создан файл \033[34;1;4mfilms_path\033[0m.\n"
	printf "\033[36;1mПожалуйста укажите директорию в которой находятся фильмы, или сериал.\n"
	printf "\033[35;1mВ будущем вы сможете изменить файл с директорией вручную.\033[0m\n\n"
	read_path
fi

######    Проверка директории на наличие файлов  #########
printf "Проверяем файл...\n\n"

FILMS_PATH=$(cat films_path)
if [ ! -d $(cat films_path) ]; then
	printf "В файле указана неверная директория.\nПопробуйте ещё раз.\n"
	read_path
fi
printf "Путь найден!\n"

get_amount_of_files
random_number_in_dir
open_random_file

exit 0
