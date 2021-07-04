import sys
import codecs
import os
import getopt
import csv
import math
import numpy as np
import scipy.stats as ss

def loopy(fn,m,n):
  header_row = [
          'X studied variable',
          'Y studied variable',
          'Computed marginal EPMF of X',
          'Computed marginal EPMF of Y',
          'Chi2',
          'Chi2 p-value',
          'Information entropy of X',
          'Information entropy of Y',
          'Joint information entropy of X and Y ',
          'Conditional information entropy of Y given X',
          'Conditional information entropy of X given Y',
          'Mutual information of X and Y',
          'Normalized mutual information of X and Y'
      ]
  w = open('inst/temp/entropy_outputs.csv', 'w+', newline = '') 
  
  with w:
    writer = csv.writer(w)
    writer.writerow(header_row)
  w.close()
  
  G = str('inst/temp/input.csv') #source data path
  Z = int(m) #First studied X variable column number
  W = Z #First studied Y variable column number
  A = int(n) #Number of studied variables
  B = Z
  C = 0
  D = 0
  
  #First part: bivariate cardinalities calculation
  def parse_command_line1():
      
      """Parse command line arguments
      """
      
      # Default parameter values
      file_name = G
      lag_Y_on_X = 0
      col_X = Z
      col_Y = W
      n_X = 0
      n_Y = 0
      separator = ','
      
      
      # Try to hash command line with respect to allowable flags
      try:
          opts, args = getopt.getopt(sys.argv[1:], "f:l:p:q:s:x:y:")
      except getopt.GetoptError:
          print("** ERROR: incorrect command line parameter(s). Exiting.")
          sys.exit(1)
  
      # Parse arguments and assign corresponding variables
      for o, a in opts:
          if o == "-f":
              file_name = a
          elif o == "-x":
              try:
                  col_X = float(a)
              except:
                  pass
          elif o == "-y":
              try:
                  col_Y = float(a)
              except:
                  pass
          elif o == "-l":
              try:
                  lag_Y_on_X = float(a)
              except:
                  pass
          elif o == "-p":
              try:
                  n_X = float(a)
              except:
                  pass
          elif o == "-q":
              try:
                  n_Y = float(a)
              except:
                  pass
          elif o == "-s":
              separator = a
      if not col_X:
          print("** ERROR: nonzero column index for variable X required. Exiting.")
          sys.exit(1)
      if not col_Y:
          print("** ERROR: nonzero column index for variable Y required. Exiting.")
          sys.exit(1)
      if lag_Y_on_X < 0:
          print("** ERROR: Y on X lag must be nonnegative. Exiting.")
          sys.exit(1)
      if n_X < 0:
          print("** ERROR: X quantization must be nonnegative. Exiting.")
          sys.exit(1)
      if n_Y < 0:
          print("** ERROR: Y quantization must be nonnegative. Exiting.")
          sys.exit(1)
      if not file_name:
          print("** ERROR: file name required. Exiting.")
          sys.exit(1)
  
      return file_name, col_X, col_Y, lag_Y_on_X, n_X, n_Y, separator
  
  def compute_cardinalities(file_name, col_X, col_Y, lag_Y_on_X, separator):
      """Get cardinalities from data file
      """
  
      # Try to parse data file
      try:
          f = open(file_name, 'r')
          lines = f.readlines()
          f.close()
      except:
          print("** ERROR: could not open {}. Exiting.".format(file_name))
          sys.exit(1)
  
      # Retrieve names of specified variable columns from first line
      names = lines[0].split(separator)
      if col_X < 0 or col_X >= len(names):
          print("** ERROR: incorrect column index for variable X: {}. Exiting.".format(
              col_X))
          sys.exit(1)
      name_X = names[col_X].strip()
      if col_Y < 0 or col_Y >= len(names):
          print("** ERROR: incorrect column index for variable Y: {}. Exiting.".format(
              col_Y))
          sys.exit(1)
      name_Y = names[col_Y].strip()
  
      # Retrieve bivariate observations over relevant data lines
      cardinalities = {}
      for l in lines[1+lag_Y_on_X:-lag_Y_on_X if lag_Y_on_X else None]:
          data = l.split(separator)
          i1 = float(data[col_X].strip())
          i2 = float(data[col_Y].strip())
          cards = cardinalities.get(i1, {})
          cards[i2] = cards.get(i2, 0) + 1
          cardinalities[i1] = cards
  
      # Perform sanity check on grand total
      n_obs = len(lines) - 1 - 2 * lag_Y_on_X
      if n_obs != sum([sum(
          [c for c in d.values()]) for d in cardinalities.values()]):
          print("** ERROR: incorrect grand total <>", n_obs)
      else:
          print("# Grand total:", n_obs)
  
      # Return variable names and values
      return name_X, name_Y, cardinalities
  
  def main():
      """Main routine
      """
      
  
      # Parse command-line arguments
      file_name, col_X, col_Y, lag_Y_on_X, n_X, n_Y, separator = parse_command_line1()
      
      # Retrieve data cardinalities from file
      name_X, name_Y, cardinalities = compute_cardinalities(
          file_name, col_X, col_Y, lag_Y_on_X, separator)
      print("# X variable name:", name_X)
      print("# Y variable name:", name_Y)
  
      # Determine and save all Y outcomes
      if n_Y:
          # Quantize Y
          out_Y = range(n_Y)
          min2 = min([min(v.keys()) for v in cardinalities.values()])
          max2 = max([max(v.keys()) for v in cardinalities.values()]) * 1.01
          sz2 = (max2 - min2) / n_Y
      else:
          out_Y = set()
          for vals in cardinalities.values():
              out_Y.update(vals.keys())
  
      # Open output file and save all Y outcomes for each X 
      f = open('inst/temp/output.csv', "w+")
      f.write(','.join([str(i) for i in out_Y]))
      f.write('\n')
  
      if n_X:
          # Quantize X
          quantized = {}
          min1 = min(cardinalities.keys())
          max1 = max(cardinalities.keys()) * 1.01
          sz1 = (max1 - min1) / n_X
          if n_Y:
              # Quantize both cardinalities
              for i1, d1 in cardinalities.items():
                  for i2, c in d1.items():
                      k1 = float((i1 - min1) // sz1)
                      k2 = float((i2 - min2) // sz2)
                      q1 = quantized.get(k1, {})
                      q1[k2] = q1.get(k2, 0) + c
                      quantized[k1] = q1
  
          else:
              # Do not quantize Y
              for i1, d1 in cardinalities.items():
                  for i2, c in d1.items():
                      k1 = float((i1 - min1) // sz1)
                      q1 = quantized.get(k1, {})
                      q1[i2] = q1.get(i2, 0) + c
                      quantized[k1] = q1
  
          # Save bivariate quantized cardinalities
          for i1 in range(n_X):
              if sum([quantized.get(i1, {}).get(oy, 0) for oy in out_Y]):
                  f.write(
                      ','.join(
                          [str(i1)] + [str(quantized.get(i1, {}).get(oy, 0)) for oy in out_Y]))
                  f.write('\n')
  
      else:
          # No quantization for X
          if n_Y:
              # Quantize Y only
              quantized = {}
              for i1, d1 in cardinalities.items():
                  for i2, c in d1.items():
                      k2 = float((i2 - min2) // sz2)
                      q1 = quantized.get(i1, {})
                      q1[k2] = q1.get(k2, 0) + c
                      quantized[i1] = q1
              for k in quantized.keys():
                  f.write(','.join(
                      [str(k)] + [str(quantized[k].get(oy, 0)) for oy in out_Y]))
                  f.write('\n')
              
          else:
              # No quantization for either variable
              for k in cardinalities.keys():
                  f.write(','.join(
                      [str(k)] + [str(cardinalities[k].get(oy, 0)) for oy in out_Y]))
                  f.write('\n')
  
      # Close output file
      f.close()
      
  while C <=  A:
      while D <  A :
          if __name__ == '__main__':
              # Execute main routine
              main()
          
          if __name__ == '__main__':
              """Main routine
              """
              
              # Default parameter values
              file2_name = 'inst/temp/output.csv'
              var_X_name = ' Variable {}'.format(C)
              var_Y_name = ' Variable {}'.format(D)
              separator = ','
          
              # Try to hash command line with respect to allowable flags
              try:
                  opts, args = getopt.getopt(sys.argv[1:], "f:x:y:s:")
              except getopt.GetoptError:
                  print("** ERROR: incorrect command line parameter(s). Exiting.")
                  sys.exit(1)
          
              # Parse arguments and assign corresponding variables
              for o, a in opts:
                  if o == "-f":
                      file2_name = a
                  elif o == "-x":
                      var_X_name = a
                  elif o == "-y":
                      var_Y_name = a
                  elif o == "-s":
                      separator = a
              if not file2_name:
                  print("** ERROR: file name required. Exiting.")
                  sys.exit(1)
          
              # Try to parse specified input file
              first_row = True
              columns_to_outcomes = None
              cardinalities = {}
              n_per_row = 0
              try:
                  with open(file2_name, newline='') as f:
                      reader = csv.reader(f, delimiter=separator, quotechar='#')
                      for row in reader:
                          # Retrieve second variable outcomes from first line
                          if first_row:
                              columns_to_outcomes = {i: s for i, s in enumerate(row)}
                              n_per_row = len(columns_to_outcomes) + 1
                              first_row = False
          
                          # Then parse and check all other lines
                          else:
                              # Sanity check
                              if len(row) != n_per_row:
                                  print("** ERROR: row has {} entries instead of {}. Exiting.".format(
                                      len(row), n_per_row))
                                  sys.exit(1)
          
                              # Append cardinalities for second variable
                              cardinalities[row[0]] = {
                                  columns_to_outcomes[i]: int(s) for i, s in enumerate(row[1:])}
          
              # Bail out if parsing failed
              except:
                  print("** ERROR: problem occurred when trying to parse {}. Exiting.".format(
                      file_name))
                  sys.exit(1)
          
              # Bail out if empty distribution
              if not cardinalities:
                  print("** ERROR: empty distribution. Exiting.".format(
                      file_name))
                  sys.exit(1)
          
              # Compute total cardinality
              n_obs = sum([sum(v.values()) for v in cardinalities.values()])
              
          
              # Compute empirical joint probability mass function
              ejpmf = {x: {y: n_xy / n_obs
                           for y, n_xy in n_x.items()} for x, n_x in cardinalities.items()} 
          
              # Compute marginal distributions
              epmf_X, epmf_Y = {}, {}
              for x, f_x in ejpmf.items():
                  epmf_X[x] = 0
                  for y, f_xy in f_x.items():
                      epmf_X[x] += f_xy
                      epmf_Y[y] = epmf_Y.get(y, 0) + f_xy
          
              # Sanity check
              if abs(sum(epmf_X.values()) - 1) > 1e-8:
                  print("** ERROR: marginal EPMF of {} does not sum to 1. Exiting.".format(
                      var_X_name))
                  sys.exit(1)
              n_X = len(epmf_X)
              
              if abs(sum(epmf_Y.values()) - 1) > 1e-8:
                  print("** ERROR: marginal EPMF of {} does not sum to 1. Exiting.".format(
                      var_Y_name))
                  sys.exit(1)
              n_Y = len(epmf_Y)
              
          
              # Compute chi-squared statistic
              chi_2 = 0
              for x, n_x in cardinalities.items():
                  for y, p_xy in n_x.items():
                      expected = epmf_X[x] * epmf_Y[y] * n_obs
                      delta = cardinalities[x][y] - expected
                      chi_2 += delta * delta / expected
              
          
              # Compute individual information entropies
              H_X = 0
              for x, p in epmf_X.items():
                  H_X -= p * math.log(p)
              
              H_Y = 0
              for y, p in epmf_Y.items():
                  H_Y -= p * math.log(p)
              
          
              # Compute mutual information entropies
              H_XY, H_Y_X, H_X_Y = 0, 0, 0
              for x, p_x in ejpmf.items():
                  for y, p_xy in p_x.items():
                      if abs(p_xy) > 1e-323:
                          H_XY -= p_xy * math.log(p_xy)
                          H_Y_X -= p_xy * math.log(p_xy / epmf_Y[y])
                          H_X_Y -= p_xy * math.log(p_xy / epmf_X[x])
              I_XY = H_XY - H_Y_X - H_X_Y
              
              
          #Print the X and Y normalized mutual information outputs row
          
          rowy = [
             "{}".format(C),
             "{}".format(D),
              n_X,
              n_Y,
              chi_2,
              (1 - ss.chi2.cdf(chi_2, df = (n_X - 1) * (n_Y - 1) )),
              H_X,
              H_Y,
              H_XY,
              H_Y_X,
              H_X_Y,
              I_XY,
              I_XY / math.sqrt(H_X * H_Y)
              ]
          
          z = open('inst/temp/entropy_outputs.csv', 'a+', newline = '')
          with z:
              writer = csv.writer(z)
              writer.writerow(rowy)
          z.close()
          
          W = W + 1
          D = D + 1
     
      Z = Z + 1
      if D == A :
          W = Z
          D = Z - B
      C = C + 1
