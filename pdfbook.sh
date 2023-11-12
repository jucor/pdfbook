#!/usr/bin/env bash
command -v pdfjam >/dev/null 2>&1 || { echo >&2 "pdfjam is required but it's not installed.  Aborting."; exit 1; }
command -v pdfinfo >/dev/null 2>&1 || { echo >&2 "pdfinfo is required but it's not installed.  Aborting."; exit 1; }
command -v awk >/dev/null 2>&1 || { echo >&2 "awk is required but it's not installed.  Aborting."; exit 1; }


input_pdf="$1"

# Check if input file is provided and exists
if [ -z "$input_pdf" ]; then
    echo "Usage: $0 <input.pdf>"
    exit 1
fi

if [ ! -f "$input_pdf" ]; then
    echo "Error: File '$input_pdf' not found."
    exit 1
fi

# Output PDF file
output_pdf="${input_pdf%.*}_book.pdf"


dimensions="$(LC_ALL=C pdfinfo $input_pdf| LC_ALL=C awk '/^Page size:/ {printf "{%fpt,%fpt}", $5, $3*2}')"
pdfjam --papersize $dimensions --tidy  --nup 2x1 --landscape $input_pdf --outfile $output_pdf

