declare -A Location
declare -A Month
declare -A NewLocation

OLDIFS=$IFS
IFS=","
ind=0
while read isocode location date cases newcases
do
    if [ $ind -eq 0 ]
    then
        echo ""
    else
        Location[$location]=0
        NewLocation[$location]=0
    fi
    ind=$(($ind+1))
done < covid.csv
ind=0
while read isocode location date cases newcases totaldeaths
do
    if [ $ind -eq 0 ]
    then
        echo ""
    else
        temp1=${Location[$location]}
        Location[$location]=$(($temp1+$cases))
        temp2=${NewLocation[$location]}
        NewLocation[$location]=$(($temp2+$newcases))
    fi
    ind=$(($ind+1))
done < covid.csv
function getLocationWithCases() {
    for K in "${!Location[@]}"
    do
        echo "$K => ${Location[$K]}" 
    done
}
function getTotalCases() {
    sum=0
    for K in "${!Location[@]}"
    do
         temp=${Location[$K]}
         sum=$(($temp+$sum))
    done
    echo "Total Cases in all Locations : $sum"
}
function getCasesByLocation() {
    echo -n "Enter Name of The Location : "
    read location
    if [ ${Location[$location]+_} ]
    then 
        val=${Location[$location]}
        echo "The no of cases in $location is $val"
    else 
        echo "$location Not found"
    fi
}
function getNewCasesInLocation() {
    echo -n "Enter Name of The Location : "
    read location
    if [ ${NewLocation[$location]+_} ]
    then 
        val=${NewLocation[$location]}
        echo "The no of new cases in $location is $val"
    else 
        echo "$location Not found"
    fi
}
function getLocationsNewCases() {
    for K in "${!NewLocation[@]}"
    do
        val=${NewLocation[$K]}
        if [ $val -eq 0 ]
        then
            echo "$K"
        fi
    done
}
flag=0
while [ $flag -eq 0 ]
do
    echo "************************************************************************"
    echo "1. Total cases in a given location" 
    echo "2. Total cases in all locations"
    echo "3. Number of cases in a given month"
    echo "4. Number of new cases in a given location"
    echo "5. Number of total cases location-wise"
    echo "6. Display location names which has new cases as zero"
    echo "7. Exit"
    echo -n "Enter Your Choice : "
    read choice 
    case $choice in
        1)
            getCasesByLocation
            ;;
        2)
            getTotalCases
            ;;
        3)
            echo "Invalid"
            ;;
        4)  
            getNewCasesInLocation
            ;;
        5)
            getLocationWithCases
            ;;
        6)  
            getLocationsNewCases
            ;;
        7)
            echo "Thank You"
            break
            ;;
        *) 
            echo "enter a valid option"
            ;;
        esac
        echo "*************************************************************************"
done