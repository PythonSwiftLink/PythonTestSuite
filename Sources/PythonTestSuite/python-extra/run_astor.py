from astor import to_source
from ast import *

def makeClass():
	return ClassDef(
		name="name",
		bases=[],
		keywords=[],
		decorator_list=[],
		body=[" ..."]
	)

def makeSource(cls) -> str:
	#print(cls)
	return to_source(cls)

def test() -> str:
	return makeSource(makeClass("test"))

if __name__ == "__main__":

	print(
		test()
	)