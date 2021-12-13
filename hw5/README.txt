How to compile my code:
	設定環境變數，在terminal輸入"export PATH=$PATH:/home/huang714/arm-tool-20.4/bin/arm-none-eabi-gcc"(我的binary file的位置)	
	在terminal輸入"make"，如果hw5_test.s、numsort.s皆存在的話，會根據makefile中定義的規則，執行 "arm-none-eabi-gcc -g -O0 numsort.s hw5_test.s -o hw5.exe"，產生名為"hw5.exe"的執行檔
	執行結束後，輸入"make clean" 執行"rm -rf hw5.exe" 將"hw5.exe"刪除
how to run my code:
	使用"command line gdb"
	在terminal輸入"arm-none-eabi-gdb -tui hw5.exe" 
	因為有設定自動設定target為simulator，也有自動load，故按兩下enter就可以開始使用了
	使用list+function在畫面的上半部產生code
		然後用"break + 行號"設定斷點，輸入"r"開始執行、搭配"n"(next)、"c"(continue)、"info register"、"x/32 + address"等指令觀察register和memory上的值
feature of my code:
	hw5_test.s:
		在data section將input array的值初始化，並設定好稍後要用的printf的format
		maint 開始
			NumSort前，先將input array的值print出來;
			NumSort結束後，再將Result array的值print出來。
		print的方法為:
			先將要print的array的名稱(input or result)給print出來
			接著print 22個"%d, "
			最後接一個"%d\n"。
			在print 22個的過程中，每次都重新取得陣列的起始地址，再將此地址加上(n-1)*4個bytes，以此取得第n個位置的值
			將要print的format丟到r0，要print的值丟到r1，接著用"bl printf"呼叫printf
	numsort.s:
		NumSort的過程與之前一樣，只是這次換成從r0取得array_size、從r1取得inpur_array的起頭。
		在sorting之前，用malloc取得記憶體空間供result_array使用。
