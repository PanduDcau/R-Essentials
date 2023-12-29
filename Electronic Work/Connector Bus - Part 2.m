import psse34

psse34.run_module("psseinit")

psse34.create_case("BasicCase.sav")
psse34.create_bus(1, kv=138, name="Bus 1", bustype=3)
psse34.create_bus(2, kv=138, name="Bus 2", bustype=1, pload=50, qload=10)
psse34.create_bus(3, kv=138, name="Bus 3", bustype=1, pload=30, qload=5)
psse34.create_line(1, 1, 2, r=0.02, x=0.1, b=0.02, mva=100)
psse34.create_line(2, 2, 3, r=0.01, x=0.05, b=0.01, mva=100)

psse34.save_case("BasicCase.sav")

psse34.run_module("Dynamics Data Setup")
psse34.run_module("Power Flow")

num_iterations_default = psse34.get_num_iterations()
print(f"Number of iterations with default tolerance: {num_iterations_default}")

psse34.run_module("Dynamics Data Setup")
psse34.run_script("ChangeParameter", "Convergence Tolerance", 1e-6)
psse34.run_module("Power Flow")

num_iterations_reduced = psse34.get_num_iterations()
print(f"Number of iterations with reduced tolerance: {num_iterations_reduced}")

psse34.close_case()
psse34.terminate()