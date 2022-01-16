all:data.txt hw7.c hw7simd.c
	@gcc hw7.c -msse -lrt -Wall -g -fsanitize=undefined -fsanitize=address -o hw7 
	@./hw7
	@gcc hw7simd.c -msse -lrt -Wall -g -fsanitize=undefined -fsanitize=address -o hw7simd 
	@./hw7simd
data.txt:make_rand_data.c
	gcc make_rand_data.c -Wall -g  -fsanitize=undefined -fsanitize=address -o make_rand_data 
	@./make_rand_data
clean:
	rm -f make_rand_data hw7simd hw7
