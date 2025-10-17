import os
import subprocess
# before running this script, go to the folder of recorded data.
# Then run Matlab script /home/kus/Documents/MyMatlab/MormannLabscripts/bonnLabScreeningPipeline/my_prepare_combinato.m
# go to a terminal, go to the datafolder, then run
#bash>python /home/kus/combinato/run_combinato_pipeline.py
# or bash>python run_combinato_pipeline.py | tee combinato_log.txt
# Define paths
combinato_path = "/home/kus/combinato"

# Extend environment variables
env = os.environ.copy()
env["PATH"] = f"{env['PATH']}:{combinato_path}"
env["PYTHONPATH"] = f"{env.get('PYTHONPATH', '')}:{combinato_path}"

# List of Combinato commands to run in sequence
commands = [
    ["css-extract", "--jobs", "do_extract"],
    ["css-find-concurrent"],
    ["css-mask-artifacts"],
    ["css-prepare-sorting", "--jobs", "do_sort_neg.txt"],
    ["css-prepare-sorting", "--jobs", "do_sort_pos.txt"],
    ["css-cluster", "--jobs", "sort_pos_kus.txt"],
    ["css-cluster", "--jobs", "sort_neg_kus.txt"],
    ["css-combine", "--jobs", "sort_pos_kus.txt"],
    ["css-combine", "--jobs", "sort_neg_kus.txt"],
]

# Run commands one by one
for cmd in commands:
    print(f"\n Running: {' '.join(cmd)}")
    try:
        subprocess.run(cmd, check=True, env=env)
        print("Done.")
    except subprocess.CalledProcessError as e:
        print(f"Error while running {' '.join(cmd)}")
        print(e)
        break  # stop if any command fails
