程式測試環境：
	- 作業系統 : Windows 10 x64
	- CPU : i5-10210U @1.60GHz
	- RAM : 8GB
	- 執行環境 : WSL 2 Ubuntu 20.04.02

How to compile and run my code：
	輸入make，電腦會根據makefile的指令查看是否"data.txt", "hw7.c", "hw7simd.c" 存在，
		若"data.txt不存在，則會看是否"make_rand_data.c"是否存在，若存在則編譯並執行，產生"data.txt"
	若三者皆存在，則執行:
		@gcc hw7.c -msse -lrt -Wall -g -fsanitize=undefined -fsanitize=address -o hw7 & ./hw7
		@gcc hw7simd.c -msse -lrt -Wall -g -fsanitize=undefined -fsanitize=address -o hw7simd & ./hw7simd
	意即編譯並執行他們，會產生三個檔案:data.txt、output.txt、output_simd.txt，並在terminal顯示執行時間的結果
		-msse是for _mm_add_ps()、_mm_mul_ps()
		-g 是產生錯誤訊息的行號
		-Wall 是一般性的錯誤檢查
		-fsanitize 是檢查記憶體的使用
		-o 為產生名為緊接著的字串的執行黨
		"& ./filename" 為執行名為"filename"的執行檔
	要清除執行檔則出入 "make clean"
Feature of my code：
	- 計算c[i]的方法是簡化老師的計算過程而成
		詳細過程如下:
			C[i] = A[i][0]*B[0][0] + A[i][1]*B[0][1] + ... + A[i][197]*B[0][197]  //i row of A * 0 row of B
                     	+ A[i][0]*B[1][0] + A[i][1]*B[1][1] + ... + A[i][197]*B[1][197]  //i row of A * 1 row of B
                     	+ A[i][0]*B[2][0] + A[i][1]*B[2][1] + ... + A[i][197]*B[2][197]  //i row of A * 2 row of B
                     	+ A[i][0]*B[3][0] + A[i][1]*B[3][1] + ... + A[i][197]*B[3][197]  //i row of A * 3 row of B
                     	+
                     	.
                     	.
                     	.
                     	+
                     	+ A[i][0]*B[200][0] + A[i][1]*B[200][1] + ... + A[i][197]*B[200][197]  //i row of A * 200 row of B
             thus, c[i] = A[i][0]*(B[0][0]+B[1][0]+...+B[200][0]) + A[i][1]*(B[0][1]+B[1][1]+...+B[200][1]) + ... + A[i][197]*(B[0][197]+B[1][197]+...+B[200][197])
                     	= A[i][0]*(sum of coloumn 0 of b) + A[i][1](sum of coloumn 1 of b) + ... + A[i][1](sum of coloumn 197 of b)
		簡單來說，先將每一column of B加總存到第0 row，接著在compute c[i]時，row i of A就只要乘以B column total就好
	- 運用intrinsic function計算c[i]的方法為：
		一次將8個float of A 和 8個 float of B相乘
			方法為:將前四個與後四個相乘的結果，個別當作參數傳入_mm_add_ps()
		將_mm_add_ps()完的結果存到temp(型態為__m128)裡
		將temp裡面的四個float加到c[i]
		重複上面步驟，直到處理完該row
	- 產生data.txt的方法
		將想要的測資範圍乘上某0~1之間的數(一個亂數乘以黃金比例(小數部分)之後取其小數部分)

使用到的SIMD指令：
	SSE裡的 _mm_add_ps()、_mm_mul_ps()

程式執行結果：
	- 運算結果
		- hw7.c 的運算結果會輸出到名為"output.txt"的檔案裡
		- hw7simd.c 的運算結果會輸出到名為"output_simd.txt"的檔案裡
	- 執行時間
		- C program without SIMD:
        		read time:      compute time:   write time:
        		0.063519        0.001641        0.000586
		- C program with SIMD:
        		read time:      compute time:   write time:
        		0.062738        0.000536        0.000483
		- 說明，read time和 write會大致相同，而compute time可以差到3倍左右
			 
