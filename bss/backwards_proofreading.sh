#!/bin/bash
# Создано специально для Александра М.

reverse_file() {
    local input_file="bss.md"
    local output_file="backwards_proofreading.txt"

    # Проверка существования входного файла
    if [[ ! -f "$input_file" ]]; then
        echo "❌ Ошибка: Файл $input_file не найден!"
        exit 1
    fi

    echo "🚀 Начало обработки файла..."
    echo "=========================================="

    # Получаем общее количество строк
    echo "📊 Подсчет статистики файла..."
    local total_lines=$(wc -l < "$input_file")
    echo "✅ Общее количество строк: $total_lines"

    # Подсчитываем общее количество символов (без символов новой строки)
    local total_chars=0
    while IFS= read -r line; do
        ((total_chars += ${#line}))
    done < "$input_file"
    echo "✅ Общее количество символов: $total_chars"
    echo

    # Шаг 1: Реверс порядка строк с прогресс-баром
    echo "🔄 Этап 1: Реверс порядка строк..."
    local current_line=0

    # Создаем временный файл для хранения реверсированных строк
    local temp_file1=$(mktemp)
    declare -a lines_arr

    {
        while IFS= read -r line; do
            lines_arr[$current_line]="$line"
            current_line=$((current_line + 1))

            # Обновляем прогресс-бар
            if [[ $((current_line % 100)) -eq 0 ]] || [[ $current_line -eq $total_lines ]]; then
                local percent=$((current_line * 100 / total_lines))
                local filled=$((percent * 50 / 100))
                local empty=$((50 - filled))

                printf "\r\033[32m🟢 [%s%s] %3d%% (%d/%d строк)\033[0m" \
                    "$(printf '█%.0s' $(seq 1 $filled))" \
                    "$(printf '░%.0s' $(seq 1 $empty))" \
                    "$percent" "$current_line" "$total_lines"
            fi
        done < "$input_file"

        echo -e "\n✅ Строки загружены в память"

        # Показываем прогресс записи в обратном порядке
        echo "📝 Запись строк в обратном порядке..."
        for ((i = current_line - 1; i >= 0; i--)); do
            echo "${lines_arr[i]}" >> "$temp_file1"

            local percent=$(((current_line - i) * 100 / current_line))
            local filled=$((percent * 50 / 100))
            local empty=$((50 - filled))

            if [[ $(((current_line - i) % 100)) -eq 0 ]] || [[ $i -eq 0 ]]; then
                printf "\r\033[32m🟢 [%s%s] %3d%% (%d/%d строк)\033[0m" \
                    "$(printf '█%.0s' $(seq 1 $filled))" \
                    "$(printf '░%.0s' $(seq 1 $empty))" \
                    "$percent" "$((current_line - i))" "$current_line"
            fi
        done
    }

    echo -e "\n✅ Этап 1 завершен!"

    # Шаг 2: Реверс символов в каждой строке с прогресс-баром
    echo
    echo "🔤 Этап 2: Реверс символов в строках..."

    # Создаем временный файл для результата
    local temp_file2=$(mktemp)
    local current_line=0
    local processed_chars=0

    {
        while IFS= read -r line; do
            # Реверсируем строку
            local reversed_line=$(echo "$line" | rev)
            echo "$reversed_line" >> "$temp_file2"

            # Обновляем счетчики
            local line_length=${#line}
            processed_chars=$((processed_chars + line_length))
            current_line=$((current_line + 1))

            # Обновляем прогресс-бар каждые 100 строк или для маленьких файлов чаще
            if [[ $((current_line % 100)) -eq 0 ]] || [[ $current_line -eq $total_lines ]]; then
                local percent=$((processed_chars * 100 / total_chars))
                local filled=$((percent * 50 / 100))
                local empty=$((50 - filled))

                printf "\r\033[32m🔠 [%s%s] %3d%% (%d/%d символов)\033[0m" \
                    "$(printf '█%.0s' $(seq 1 $filled))" \
                    "$(printf '░%.0s' $(seq 1 $empty))" \
                    "$percent" "$processed_chars" "$total_chars"
            fi
        done < "$temp_file1"
    }

    echo -e "\n✅ Этап 2 завершен!"

    # Копируем результат в выходной файл
    cp "$temp_file2" "$output_file"

    # Удаляем временные файлы
    rm -f "$temp_file1" "$temp_file2"

    echo
    echo "=========================================="
    echo "🎉 Обработка завершена!"
    echo "💾 Результат сохранен в: $output_file"

    # Показываем информацию о результате
    local output_lines=$(wc -l < "$output_file")
    local output_chars=0
    while IFS= read -r line; do
        ((output_chars += ${#line}))
    done < "$output_file"
    echo "📊 Обработано строк: $output_lines"
    echo "📊 Обработано символов: $output_chars"
}

# Запускаем функцию
reverse_file
