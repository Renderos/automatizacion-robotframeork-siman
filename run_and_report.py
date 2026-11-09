#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script para ejecutar pruebas y generar reportes detallados automáticamente
Uso: python run_and_report.py <environment> [suite] [opciones de run_tests.py]
"""

import os
import sys
import shutil
import subprocess
from generate_detailed_report import DetailedReportGenerator
from export_test_reports import ReportExporter


LATEST_FILE = os.path.join("results", "executions", "latest.txt")


def read_latest_execution_dir():
    """Carpeta con fecha y hora que creó run_tests.py en esta ejecución"""
    if os.path.exists(LATEST_FILE):
        with open(LATEST_FILE, encoding="utf-8") as f:
            path = f.read().strip()
        if path and os.path.isdir(path):
            return path
    return None


def archive_reports(execution_dir):
    """Copia el reporte detallado y los exports a la carpeta de la ejecución para que no se sobrescriban"""
    copied = []
    detailed = os.path.join("results", "DETAILED_REPORT.html")
    if os.path.exists(detailed):
        shutil.copy2(detailed, os.path.join(execution_dir, "DETAILED_REPORT.html"))
        copied.append("DETAILED_REPORT.html")
    exports = os.path.join("results", "exports")
    if os.path.isdir(exports):
        shutil.copytree(exports, os.path.join(execution_dir, "exports"), dirs_exist_ok=True)
        copied.append("exports/")
    return copied


def run_tests_and_generate_reports(env, extra_args=()):
    """Ejecuta pruebas y genera todos los reportes"""

    print("\n" + "="*70)
    print(f"  EJECUTANDO PRUEBAS Y GENERANDO REPORTES - {env.upper()}")
    print("="*70 + "\n")

    # Paso 1: Ejecutar pruebas
    print("📝 PASO 1: Ejecutando pruebas...")
    print("-" * 70)
    result = subprocess.run(
        [sys.executable, "run_tests.py", env, *extra_args],
        cwd=os.getcwd()
    )

    if result.returncode != 0:
        print("\n⚠️ Las pruebas tuvieron problemas, pero continuaremos con los reportes...\n")
    else:
        print("\n✅ Pruebas completadas exitosamente\n")

    # Paso 2: Generar reporte HTML detallado
    print("\n📊 PASO 2: Generando reporte HTML detallado...")
    print("-" * 70)
    try:
        generator = DetailedReportGenerator()
        tests_info = generator.get_test_details()
        generator.generate_html_report(tests_info)
    except Exception as e:
        print(f"❌ Error al generar reporte HTML: {e}")

    # Paso 3: Exportar a múltiples formatos
    print("\n📁 PASO 3: Exportando a múltiples formatos...")
    print("-" * 70)
    try:
        exporter = ReportExporter()
        exporter.export_all()
    except Exception as e:
        print(f"❌ Error al exportar reportes: {e}")

    # Paso 4: Guardar copia en la carpeta de esta ejecución
    execution_dir = read_latest_execution_dir()
    if execution_dir:
        copied = archive_reports(execution_dir)
        if copied:
            print(f"\n📦 Copia guardada en {execution_dir}: {', '.join(copied)}")

    # Resumen final
    print("\n" + "="*70)
    print("  RESUMEN DE REPORTES GENERADOS")
    print("="*70)
    print("\n📂 Última ejecución (se sobrescriben en cada corrida):\n")
    print("  1. HTML Detallado:     results/DETAILED_REPORT.html")
    print("  2. Reporte Estándar:   results/report.html")
    print("  3. Log Completo:       results/log.html")
    print("  4. JSON:               results/exports/results.json")
    print("  5. CSV Tests:          results/exports/test_results.csv")
    print("  6. CSV Keywords:       results/exports/keyword_results.csv")
    print("  7. Markdown:           results/exports/REPORTE.md")
    print("  8. Dashboard:          results/dashboards/index.html")
    if execution_dir:
        print(f"\n📁 Esta ejecución (no se sobrescribe): {execution_dir}")
    print("\n" + "="*70)
    print("✅ Proceso completado\n")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("❌ Uso: python run_and_report.py <environment> [suite] [opciones de run_tests.py]")
        print("   Ejemplos:")
        print("   - python run_and_report.py sandbox")
        print("   - python run_and_report.py prod")
        print("   - python run_and_report.py sandbox tests/demo -v DEMO_SPEED:0.3s")
        sys.exit(1)

    env = sys.argv[1]
    run_tests_and_generate_reports(env, sys.argv[2:])
