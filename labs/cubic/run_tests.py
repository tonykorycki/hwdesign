import os
import shutil
import shutil
import numpy as np
import pandas as pd
import json
import zipfile

class GradescopeTest:
    def __init__(self,
                 name : str,
                 max_score : int):
        self.name = name
        self.max_score = max_score
        
    def run(self, **kwargs):
        """
        Runs the test
        
        Returns:
        --------
        score : int
            The score obtained in the test
        feedback : str
            Feedback message for the test
        """
        raise NotImplementedError("Subclasses should implement this!")
    
    
class TestPython(GradescopeTest):
    def __init__(
            self,
            wid : int = 16,
            fbits : int = 8,
            threshold=1e-5):

        self.wid = wid
        self.fbits = fbits
        self.threshold = threshold
        super().__init__(
            name=f"Python Implementation W={wid}, F={fbits}", 
            max_score=10)
    def run(self):
        """
        Test Python implementation by reading CSV and computing MSE.
        """
        # Construct CSV filename
        csv_file = f'test_outputs/tv_w{self.wid}_f{self.fbits}.csv'
        
        try:
            # Read CSV file
            df = pd.read_csv(csv_file)
            
            # Check if there are enough samples
            num_samples = len(df)
            if num_samples < 100:
                score = 0
                feedback = f"Insufficient samples: {num_samples} samples found, but at least 100 required."
                return score, feedback
            
            # Extract y and yfix columns
            if 'y' not in df.columns or 'yfix' not in df.columns:
                score = 0
                feedback = "Error: Required columns 'y' and 'yfix' not found in CSV file."
                return score, feedback
            
            y = df['y'].values
            yfix = df['yfix'].values
            
            # Compute MSE
            mse = np.mean((y - yfix) ** 2) / np.mean(y ** 2)

            # Compute score
            excess_mse = max(0, (mse - self.threshold)/(10*self.threshold))
            score = int(round( self.max_score * max(1 - excess_mse, 0) ))
                    
            # Determine score based on MSE
            if score < self.max_score and score > 0:
                feedback = f"Partial credit: MSE: {mse:.6e} (threshold: {self.threshold:.6e}), Score: {score}/{self.max_score}"
            elif score == 0:
                feedback = f"MSE too high: {mse:.6e} (threshold: {self.threshold:.6e})"
            else:
                score = self.max_score
                feedback = f"Test passed! MSE: {mse:.6e} (threshold: {self.threshold:.6e})"
            
            return score, feedback
            
        except FileNotFoundError:
            score = 0
            feedback = f"Error: File '{csv_file}' not found."
            return score, feedback
        except Exception as e:
            score = 0
            feedback = f"Error reading or processing file: {str(e)}"
            return score, feedback
        
class TestSV(GradescopeTest):
    def __init__(
            self,
            wid : int = 16,
            fbits : int = 8,
            threshold=1e-5):

        self.wid = wid
        self.fbits = fbits
        self.threshold = threshold
        super().__init__(
            name=f"SystemVerilog Implementation W={wid}, F={fbits}", 
            max_score=10)
    def run(self):
        """
        Test SystemVerilog implementation by reading CSV and computing MSE.
        """
        # Construct CSV filename
        csv_file = f'test_outputs/tv_w{self.wid}_f{self.fbits}_sv.csv'
        try:
            # Read CSV file
            df = pd.read_csv(csv_file)
            
            # Check if there are enough samples
            num_samples = len(df)
            if num_samples < 100:
                score = 0
                feedback = f"Insufficient samples: {num_samples} samples found, but at least 100 required."
                return score, feedback
            
            # Extract yint and y_dut columns
            if 'yint' not in df.columns or 'y_dut' not in df.columns:
                score = 0
                feedback = "Error: Required columns 'yint' and 'y_dut' not found in CSV file."
                return score, feedback
            
            yint = df['yint'].values
            y_dut = df['y_dut'].values
            
            # Compute MSE: mean((yint - y_dut)^2) / mean(yint^2)
            mse = np.mean((yint - y_dut) ** 2) / np.mean(yint ** 2)
            
            # Calculate score: 10*max(1 - mse, 0)
            score = int(round(self.max_score * max(1 - mse, 0)))
            
            # Generate feedback
            if score == self.max_score:
                feedback = f"Test passed! MSE: {mse:.6e}"
            elif score > 0:
                feedback = f"Partial credit: MSE: {mse:.6e}, Score: {score:.2f}/{self.max_score}"
            else:
                feedback = f"MSE too high: {mse:.6e}"
            
            return score, feedback
            
        except FileNotFoundError:
            score = 0
            feedback = f"Error: File '{csv_file}' not found."
            return score, feedback
        except Exception as e:
            score = 0
            feedback = f"Error reading or processing file: {str(e)}"
            return score, feedback


def submit(
    test_outputs : list,
    total_score : float,
):
    
    
    # Check if required files exist
    tv_dir = os.path.join(os.getcwd(), 'test_outputs')
    zip_files = [ os.path.join(os.getcwd(),'cubic.ipynb'),\
                os.path.join(os.getcwd(),'cubic.sv'),\
                os.path.join(os.getcwd(),'tb_cubic.sv'),\
                os.path.join(tv_dir, 'tv_w16_f8.csv'),\
                os.path.join(tv_dir, 'tv_w16_f8_sv.csv'),\
                os.path.join(tv_dir, 'tv_w16_f12.csv'),\
                os.path.join(tv_dir, 'tv_w16_f12_sv.csv')]
    for f in zip_files:
        if not os.path.isfile(f):
            print(f"Error: Required file {f} not found in current directory.")
            exit(1)

    # Build results in new format
    results = {
        'tests': test_outputs,
        'score': total_score
    }


    # Write results to a JSON file
    with open('submitted_results.json', 'w') as f:
        json.dump(results, f, indent=4)

    # Create submission directory
    submission_dir = 'submission'
    if os.path.exists(submission_dir):
        shutil.rmtree(submission_dir)
    os.makedirs(submission_dir)

    # Copy files to submission directory
    shutil.copy('submitted_results.json', os.path.join(submission_dir, 'submitted_results.json'))
    for f in zip_files:
        shutil.copy(f, os.path.join(submission_dir, os.path.basename(f)))

    # Create submission.zip containing the results and required source files
    with zipfile.ZipFile('submission.zip', 'w') as zipf:
        zipf.write('submitted_results.json', arcname='submitted_results.json')
        for f in zip_files:
            zipf.write(f, arcname=os.path.basename(f))

    print("Submission package created: submission.zip")
    print("Submission directory created: submission/")
    print("Upload submission.zip to Gradescope.")

def main():
    import argparse


    # List of possible tests
    tests = {
        'python_f8': TestPython(fbits=8, threshold=1e-5),
        'python_f12' : TestPython(fbits=12, threshold=0.2),
        'sv_f8': TestSV(fbits=8, threshold=1e-5),
        'sv_f12': TestSV(fbits=12, threshold=0.2)
    }
    
    # Set up argument parser
    parser = argparse.ArgumentParser(description='Run tests for cubic lab')
    parser.add_argument('--tests', nargs='+', default=['python_f8'], 
                        help='List of tests to run (e.g., python_f8, python_f12, all)')
    parser.add_argument('--submit', action='store_true',
                        help='Create submission package after running tests')
    args = parser.parse_args()
    
    # Initialize list to store test outputs
    test_outputs = []
    
    # Determine which tests to run
    if 'all' in [t.lower() for t in args.tests]:
        # Run all tests
        tests_to_run = tests.keys()
    else:
        # Run only specified tests
        tests_to_run = [t.lower() for t in args.tests]

    # Loop over the list of tests
    for tname, tclass in tests.items():
        if tname.lower() in tests_to_run:
            print(f"Running test: {tname}")
            
            # Run the test with default parameters
            score, feedback = tclass.run()
            
            # Create test output dictionary
            test_out = {
                'name': tclass.name,
                'max_score': tclass.max_score,
                'score': score, 
                'feedback': feedback
            }
            
            # Add to list of test outputs
            test_outputs.append(test_out)
            
            # Print test result
            print(f"\n{tclass.name}:")
            print(f"  Score: {test_out['score']}/{tclass.max_score}")
            print(f"  Feedback: {feedback}")
    
    # Print summary
    print("\n" + "="*60)
    print("Test Summary")
    print("="*60)
    total_score = 0
    total_max_score = 0
    for test_out in test_outputs:
        print(f"{test_out['name']}: {test_out['score']}/{test_out['max_score']}")
        total_score += test_out['score']
        total_max_score += test_out['max_score']
    print("="*60)
    print(f"Total Score: {total_score}/{total_max_score}")
    
    # Call submit if --submit flag is set
    if args.submit:
        print("\n" + "="*60)
        print("Creating submission package...")
        print("="*60)
        submit(test_outputs, total_score)
    
    return test_outputs


if __name__ == "__main__":
    main()

