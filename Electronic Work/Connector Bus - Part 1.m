import psse34

psse34.run_module("psseinit")

psse34.create_bus(1, kv=1.0, name="Bus 1", bustype=3) 
psse34.create_bus(2, kv=1.0, name="Bus 2", load=50, shunt=5, bustype=1)  
psse34.create_bus(3, kv=1.0, name="Bus 3", load=60, shunt=10, bustype=1) 

psse34.create_line(1, 1, 2, r=0.024, x=0.01, b=0, mva=100, length=10, name="Line 1")
psse34.create_line(2, 2, 3, r=0.015, x=0.005, b=0, mva=100, length=10, name="Line 2")

psse34.create_machine(1, 1, id=1, pg=120, qg=100, mva=100, status=1, name="Generator")

psse34.save_case("first.sav")

psse34.close_case()
psse34.terminate()