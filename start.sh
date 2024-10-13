#!/bin/bash
#---------------------------------------------
# FDX68 Menu 
# By Hando 2024/8/16  twitter:@FF14_hando
#---------------------------------------------
#---- FDD Emu Option ----
#PC-88/FM77AV
emuop="x0 "

#FM77AV20~
#emuop="x0 -s half"

#---- FDD CONTROL DUMP OPTION ----
#X68000
#dumpop="-c 80 high "

#PC-8801FH/FM77AV (2D)
dumpop="-c 40 -d double "

#PC-8801MA (2D)
#dumpop="-c 40 -d double -p2 -p4 -p12 "

#PC-8801MA (2DD)
#dumpop="-c 80 -d double -p2 -p12"

#PC-8801MA (2HD)
#dumpop="-c 80 -d high -p2"

#---- FDX68 Dir Name
cd ~/FDX68/ 
#---------------------------------------------


while true
do
echo -e "\e[32m=== FDX68 MENU ===\e[m"
echo "1)FDD Emulator mode"
echo "2)FDD Control  mode"
echo "3)FDD Utility"	
echo "q)EXIT"
read -p '>' sel

case $sel  in
	1)
		ls -d */
		echo "0 DRIVE"
		read  -e -r -p '>' d0
		if [ -n "$d0" ]; then
			echo "1 DRIVE"
			read -e -r -p '>' d1
		
			if [ -z "$d1" ]; then
				#echo "sudo ./fddemu -0 $d0 -o $EMU_OP &"
				sudo ./fddemu -0 $d0 -o $EMUOP &
			else
				#echo "sudo ./fddemu -0 $d0 -1 $d1 -o x0 &"
				sudo ./fddemu -0 $d0 -1 $d1 -o $EMUOP &
			fi
			sleep 1
			while true
			do
				echo -e "\e[33m=== FDD CONTROL ===\e[m"
				echo "1)FDD INSERT"
				echo "2)FDD EJECT"
				echo "3)FDD PROTECT"
				echo "4)PRINT DEVICE LIST"
				echo "q)EXIT(STOP)"
				read sel
				case $sel in
					1)
						read -p 'ID:' ID 
						read -e -r -p 'FILENAME:' FIL
						if [ -n "$ID" ] && [ -n "$FIL" ]; then				
							sudo ./fddctl -i $ID -c insert $FIL
						fi					
						;;
					2)
						read -p "ID:" ID
						if [ -n "$ID" ]; then
							sudo ./fddctl -i $ID -c eject
						fi
						;;
					3)
						read -p "ID:" ID
						if [ -n "$ID" ]; then
							sudo ./fddctl -i $ID -c protect
						fi
						;;
						
					4)
						sudo ./fddctl -l
						;;	
					[qQ])
						sudo ./fddctl --stop
						break;;
				esac
			done
		fi
		;;
	2)
		while true
		do
		echo -e "\e[33m=== FDD CONTROL MODE ===\e[m"
		echo "1) DUMP"
		echo "2) RESTORE"
		echo "q) EXIT"
		read -p ">" sel
		case $sel in
			1)
				echo -e "\e[33m=== FORMAT ===\e[m"
				echo "1) encode"
				echo "2) raw"				
				read -p ">" sel
				case $sel in
					1)
					format=""
					;;
					2)
					format="-f raw "
					;;
					*)
					format=""
					;;
				esac
				read -e -r -p "FILENAME:" FIL
				if [ -n "$FIL"];then
					sudo ./fddump -i 0 $dumpop $format $FIL
				fi	
				;;
			2)
				echo "*** NOT IMPLEMENTED ***"
				;;
			[qQ])
				break
				;;
		esac
        done
        ;;
	3)
		while true
		do
		echo -e "\e[33m=== FD UTILITY ===\e[m"
		echo "1) FDX INFO"
		echo "2) CREATE DISK"
		echo "3) SET FDX INFO"
		echo "4) DISKIMAGE VIEW"
		echo "5) COPY TRACK"
		echo "6) CONVERT DISK"
		echo "q) EXIT"
		read -p ">" sel
		case $sel in
			1)
				read -e -r -p "FILE:" FIL
				if [ -n "$FIL" ]; then
					./fdxtool $FIL
				fi	
				;;
			2)
				read -p "TYPE(2D/2DD/2HD):" TYPE
				read -e -r -p "FILENAME(FDX):" FIL
				if [ -n "$FIL" ]; then
					./fdxtool -c -t $TYPE $FIL
				fi
				;;
			3)
				read -p "NAME:" NAM
				read -p "PROTECT(on/off)" PT
				read -e -r -p "FILE:" FIL
				if [ -n "$FIL" ]; then
					if [ -z "$NAM" ]; then
						./fdxtool -s -p $PT $FIL
					else
						./fdxtool -s -n $NAM -p $PT $FIL
					fi
				fi
				;;
			4)
				echo "*** NOT IMPLEMENTED ***"			
			;;
			5)
				echo "*** NOT IMPLEMENTED ***"
			;;
			6)
			read -e -r -p "SRCFILE [MULTI -n x]:" SCR
			if [ -n "$SCR" ]; then
				read -e -r -p "DESTFILE [FORMAT -f (encode/raw)]:" DEST
				if [ -n "$DEST" ]; then
					./fdxconv -i $SCR -o $DEST 
				fi
			fi
			;;
			[Qq])
				break
				;;
		esac
		done
		;;
	[Qq])
		echo "Bye..."
		exit 0;;
esac
		
	
done 

