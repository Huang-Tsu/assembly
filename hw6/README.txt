How to compile my code:
	設定環境變數：
		在Terminal輸入:"export PATH=$PATH:/home/huang714/arm-tool-20.4/bin"(我的binary file的位置)	
	在terminal輸入"make"，如果hw6_test.s、numsort.s皆存在的話，會根據makefile中定義的規則，執行 "arm-none-eabi-gcc -g -O0 numsort.s hw6_test.s -o hw6.exe"，產生名為"hw6.exe"的執行檔
	執行結束後，輸入"make clean" 執行"rm -rf hw6.exe" 將"hw6.exe"刪除
how to run my code:
	使用"command line gdb"：
		在terminal輸入"arm-none-eabi-gdb -tui hw6.exe" 
		因為有設定自動設定target為simulator，也有自動load，故按兩下enter就可以開始使用了
		使用list+function在畫面的上半部產生code
			然後用"break + 行號"設定斷點，輸入"r"開始執行、搭配"n"(next)、"c"(continue)、"info register"、"x/32 + address"等指令觀察register和memory上的值
feature of my code:
	此次的作業重點在於將integer array 轉為 character array，以及將結果用semihosting放入其他file當中。
		***** 轉換的過程我用到了以下C function: *****
			sprintf(), strlen()
		轉換的方法為：
			先將第一個數值用sprintf搭配format1存到result_array (因為第一個的format跟其他人不同)
			接著用LOOP
				每一次開頭都用strlen()得到已經轉換出來的result_array的長度
				而sprintf要插入的位置(起頭位置(r0))就是result_array的結尾( result_array+strlen(result_array) )
				從sorted array讀取一個值，並將sorted array 的值往後移一個word(4 bytes)
				將讀到的值用sprintf搭配format2放入result_array中
				如此循環往復，直到所有的值都被轉換
	將結果輸出到另一個檔案:
		在程式最一開始的地方先將SWI instructions的地址都set好
		並將各instruction會用到的argument array的空間也準備好
		
		接著依序使用open, write, close
		執行每個指令前都要將該instruction需要的arguments放入他們的argument array
		比較特別的是write需要輸入字串的長度，所以在使用SWI之前要先用strlen()取得輸入字串的長度
