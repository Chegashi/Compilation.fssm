./prog $1 >errb
rm -rf ./algo

if [ -s ./errb ] 
then
     cat ./errb
else
    rm -rf ./algo
    gcc -o algo algo.c -w 2>errc
    if [ -s ./errc ]
    then
    cat ./errc
    else
        chmod 777 ./algo
        ./algo
    fi
fi


