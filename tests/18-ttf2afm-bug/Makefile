include ../Common.mak

test:
	# $(ttf2afm)
	# $(ttf2afm) ./SourceCodePro-Regular.ttf
	# $(ttf2afm) -u ./SourceCodePro-Regular.ttf
	$(ttf2afm) -e ./ec-uni.enc -u ./SourceCodePro-Regular-latest.ttf >f

help:
	$(ttf2afm)

dump:
	ttx -t name SourceCodePro-Regular-latest.ttf 
	ttx -t name SourceCodePro-Regular-working.ttf 


clean:
	$(clean)
	rm -f *.ttx f

rebuild:
	$(rebuild)
