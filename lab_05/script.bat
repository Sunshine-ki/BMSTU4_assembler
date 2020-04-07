masm src/data data.obj
masm src/input input.obj
masm src/main main.obj
masm src/output output.obj

link data.obj input.obj main.obj output.obj

del data.obj
del input.obj
del main.obj
del output.obj