#!/bin/bash

USER="vtb"  # Логин
HOSTS=(
    #Добавить хосты)

DEST=""
SRC=""

SSH_OPTS=(-o StrictHostKeyChecking=accept-new)

mkdir -p "$DEST"

for host in "${HOSTS[@]}"; do
    echo "->копирование с хоста $host"

    #Проверка существования директории
    if ! ssh "${SSH_OPTS[@]}" "${USER}@${host}" "test -d '${SRC}'"; then
        echo "ПРОПУСК: на $host нет директории $SRC (либо отсутствует доступ)"
        continue
    fi
    #Копирование
    mkdir -p "$DEST/$host"
    if scp "${SSH_OPTS[@]}" "${USER}@${host}:${SRC}/"*".keytab" "$DEST/$host/"; then
        echo "Успешно: $host"
    else
        echo "ОШИБКА при копировании с $host"
    fi
done
echo "=>Готово"
