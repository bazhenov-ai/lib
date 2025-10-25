#!/usr/bin/env python3
# Создано специально для Александра М.
import os
import sys

def print_progress_bar(prefix, current, total, bar_length=50, is_chars=False):
    """Выводит зеленый прогресс-бар с иконками"""
    if total == 0:
        return

    percent = int(current * 100 / total)
    filled_length = int(bar_length * current // total)
    bar = '█' * filled_length + '░' * (bar_length - filled_length)

    unit = "символов" if is_chars else "строк"
    print(f'\r\033[92m{prefix} [{bar}] {percent}% ({current}/{total} {unit})\033[0m', end='', flush=True)

def reverse_file():
    input_file = "input.txt"
    output_file = "output.txt"

    # Проверка существования входного файла
    if not os.path.exists(input_file):
        print("❌ Ошибка: Файл input.txt не найден!")
        return

    print("🚀 Начало обработки файла...")
    print("==========================================")

    # Чтение файла и подсчет статистики
    print("📊 Подсчет статистики файла...")
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            lines = f.readlines()
    except UnicodeDecodeError:
        # Если UTF-8 не работает, пробуем системную кодировку
        with open(input_file, 'r') as f:
            lines = f.readlines()

    total_lines = len(lines)

    # Подсчет общего количества символов (без символов новой строки)
    total_chars = 0
    for line in lines:
        total_chars += len(line.rstrip('\n\r'))

    print(f"✅ Общее количество строк: {total_lines}")
    print(f"✅ Общее количество символов: {total_chars}")
    print()

    # Этап 1: Реверс порядка строк
    print("🔄 Этап 1: Реверс порядка строк...")
    reversed_lines = []

    for i in range(total_lines - 1, -1, -1):
        reversed_lines.append(lines[i])
        current_processed = total_lines - i
        print_progress_bar("🟢", current_processed, total_lines)

    print("\n✅ Этап 1 завершен!")

    # Этап 2: Реверс символов в каждой строке
    print("\n🔤 Этап 2: Реверс символов в строках...")
    final_lines = []
    processed_chars = 0

    for i, line in enumerate(reversed_lines):
        # Убираем символы новой строки, реверсируем, и добавляем обратно
        cleaned_line = line.rstrip('\n\r')
        reversed_chars = cleaned_line[::-1] + '\n'
        final_lines.append(reversed_chars)

        processed_chars += len(cleaned_line)
        print_progress_bar("🔠", processed_chars, total_chars, is_chars=True)

    print("\n✅ Этап 2 завершен!")

    # Запись результата
    print("\n💾 Запись результата...")
    try:
        with open(output_file, 'w', encoding='utf-8') as f:
            f.writelines(final_lines)
    except:
        with open(output_file, 'w') as f:
            f.writelines(final_lines)

    # Подсчет статистики результата
    output_chars = 0
    for line in final_lines:
        output_chars += len(line.rstrip('\n\r'))

    print("==========================================")
    print("🎉 Обработка завершена!")
    print(f"💾 Результат сохранен в: {output_file}")
    print(f"📊 Обработано строк: {total_lines}")
    print(f"📊 Обработано символов: {total_chars}")

if __name__ == "__main__":
    reverse_file()
