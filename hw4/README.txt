How to compile my code:
	在terminal輸入"make"，如果hw4_test.s、numsort.s皆存在的話，會根據makefile中定義的規則，執行 "~/arm-tool-20.4/bin/arm-none-eabi-gcc -g -O0 numsort.s hw4_test.s -o hw4.exe"，產生名為"hw4.exe"的執行檔
	※arm-none-eabi-gcc前的路徑要根據使用者端的檔案位置修改
	執行結束後，輸入"make clean" 執行"rm -rf hw4.exe" 將"hw4.exe"刪除
how to run my code:
	這次我是使用command line gdb。
	在terminal輸入"~/arm-tool-20.4/bin/arm-none-eabi-gdb -tui"(arm-none-eabi-gcc前的路徑要根據使用者端的檔案位置修改)
	接著輸入"file hw4.exe"、"target sim"、"load"
	因為主要要觀察的是sort的行為，故直接輸入"list NumSort"，上半部即會出現numsort.s的code
		然後用"break + 行號"設定斷點，輸入"r"開始執行、搭配"n"(next)、"c"(continue)、"info register"、"x/32 + address"等指令觀察記憶體的位置以及值
feature of my code:
	在"hw4_test.s"的data section中將input_array初始化
	在"numsort.s"的data section中申請一段記憶體空間當作output_array
		然後將input_array的值一個一個複製到output_array中
			複製的方法為用迴圈的方式，每次將一個值中input_array中存到一個暫時的register，接著將此值存到output_array
	array的值複製完後就開始進行sort。此次實作的sort為bubble sort
		因為bubble每次會找出一個最大值將其放到array的最後面，故需要找array_size-1次的最大值。一開始沒有注意到這點，導致出錯。
		而bubble sort內層的迴圈則是從第一個位置開始，兩值不斷比較，將大的值往後放，
			比較的次數為"array_size-1(外層為迴圈的總次數)-外層迴圈執行的次數"，因為美執行一次就會找出一個最大，被找出來的值就不需要再比較了。
			關於bubble sort資料交換的過程，我是將取出array兩個位置的值放到兩個registers中，比較這兩個registers
				特別的是，後續交換的過程我是用condictional instrucions，也就是所有交換的指令都後墜"gt"，只在前一個register大於後一個register時執行。
