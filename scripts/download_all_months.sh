
# info to construct the data url
MONTHS=("jan" "feb" "mar" "apr" "may" "jun" "jul" "aug" "sep" "oct" "nov" "dec" )
NAME="VOSClim_GTS_"
EXT=".txt"
URL="https://www1.ncdc.noaa.gov/pub/data/vosclim"
CURL="curl --silent --output /dev/null -O"

# MUST pass a year as an arg
YEAR=$1

# creates a directory for current year
eval "mkdir -p data/${YEAR}"
eval "cd data/${YEAR}"

# downloads the files of all months of YEAR
for i in "${MONTHS[@]}"
do
    filename="${NAME}${i}_${YEAR}${EXT}"
    fullURL="${URL}/${YEAR}/${filename}"
    newCMD="${CURL} ${fullURL}"
    eval $newCMD | tee tmp
    echo "Downloaded ${filename}"
done


