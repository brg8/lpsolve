require "rspec"
require "./lib/opl.rb"

describe "lpsolve" do
	before :all do
	end

	before :each do
	end

	it "solves problem 1" do
		lp = maximize(
			"10x1 + 6x2 + 4x3",
		subject_to([
			"x1 + x2 + x3 <= 100",
			"10x1 + 4x2 + 5x3 <= 600",
			"2x1 + 2x2 + 6x3 <= 300",
			"x1 >= 0",
			"x2 >= 0",
			"x3 >= 0"
		]))
		lp.solution["x1"].to_f.round(2).should eq 33.33
		lp.solution["x2"].to_f.round(2).should eq 66.67
		lp.solution["x3"].to_f.round(2).should eq 0.0
		lp.objective.optimized_value.to_f.round(2).should eq 733.33
	end

	it "solves problem 2" do
		lp = maximize(
			"x + y - z",
		subject_to([
			"x + 2y <= 3",
			"3x-z <= 5",
			"x >= 0",
			"y >= 0",
			"z >= 0"
		]))
		lp.solution["x"].to_f.round(2).should eq 1.67
		lp.solution["y"].to_f.round(2).should eq 0.67
		lp.solution["z"].to_f.round(2).should eq 0.0
		lp.objective.optimized_value.to_f.round(2).should eq 2.33
	end

	it "solves problem 3" do
		lp = minimize(
			"a - x4",
		subject_to([
			"a + x4 >= 4",
			"a + x4 <= 10",
			"a >= 0"
		]))
		lp.solution["a"].to_f.round(2).should eq 0.0
		lp.solution["x4"].to_f.round(2).should eq 10.0
		lp.objective.optimized_value.to_f.round(2).should eq -10.0
	end

	it "solves problem 4" do
		lp = maximize(
			"x[1] + y + x[3]",
		subject_to([
			"x[1] + x[3] <= 3",
			"y <= 4",
		]))
		lp.solution["x[1]"].to_f.round(2).should eq 3.0
		lp.solution["x[3]"].to_f.round(2).should eq 0.0
		lp.solution["y"].to_f.round(2).should eq 4.0
		lp.objective.optimized_value.to_f.round(2).should eq 7.0
	end

	it "solves problem 5" do
		lp = minimize(
			"sum(i in [0,1,2,3], x[i])",
		subject_to([
			"x[1] + x[2] >= 3",
			"x[0] >= 0",
			"x[3] >= 0"
		]))
		(lp.solution=={"x[1]"=>"3.0", "x[2]"=>"0.0", "x[0]"=>"0.0", "x[3]"=>"0.0"}).should eq true
		lp.objective.optimized_value.to_f.round(2).should eq 3.0
	end

	it "solves problem 6" do
		lp = minimize(
			"sum(i in (0..3), x[i])",
		subject_to([
			"x[1] + x[2] >= 3",
			"x[0] >= 0",
			"x[3] >= 0"
		]))
		(lp.solution=={"x[1]"=>"3.0", "x[2]"=>"0.0", "x[0]"=>"0.0", "x[3]"=>"0.0"}).should eq true
		lp.objective.optimized_value.to_f.round(2).should eq 3.0
	end

	it "solves problem 7" do
		lp = minimize(
			"z + sum(i in (0..3), x[i])",
		subject_to([
			"x[1] + x[2] >= 3",
			"z >= 3",
			"x[0] >= 0",
			"x[1] >= 0",
			"x[2] >= 0",
			"x[3] >= 0"
		]))
		(lp.solution=={"x[1]"=>"3.0", "x[2]"=>"0.0", "z"=>"3.0", "x[0]"=>"0.0", "x[3]"=>"0.0"}).should eq true
		lp.objective.optimized_value.to_f.round(2).should eq 6.0
	end

	it "solves problem 8" do
		lp = minimize(
			"sum(i in (0..1), j in [0,1], x[i][j])",
		subject_to([
			"sum(j in (0..1), x[1][j]) >= 3",
			"x[1][0] >= 1",
			"x[1][0] <= 1",
			"x[0][0] + x[0][1] >= 0"
		]))
		lp.solution["x[1][0]"].to_f.round(2).should eq 1.0
		lp.solution["x[1][1]"].to_f.round(2).should eq 2.0
		lp.solution["x[0][0]"].to_f.round(2).should eq 0.0
		lp.solution["x[0][1]"].to_f.round(2).should eq 0.0
		lp.objective.optimized_value.to_f.round(2).should eq 3.0
	end

	it "solves problem 9" do
		lp = minimize(
			"sum(i in (0..1), j in [0,1], x[i][j])",
		subject_to([
			"sum(i in (0..1), j in [0,1], x[i][j]) >= 10"
		]))
		(lp.solution=={"x[0][0]"=>"10.0", "x[0][1]"=>"0.0", "x[1][0]"=>"0.0", "x[1][1]"=>"0.0"}).should eq true
		lp.objective.optimized_value.to_f.round(2).should eq 10.0
	end

	it "solves problem 10" do
		lp = minimize(
			"sum(i in (0..3), x[i])",
		subject_to([
			"sum(i in (0..1), x[i]) + sum(i in [2,3], 2x[i]) >= 20"
		]))
		(lp.solution=={"x[0]"=>"0.0", "x[1]"=>"0.0", "x[2]"=>"10.0", "x[3]"=>"0.0"}).should eq true
		lp.objective.optimized_value.to_f.round(2).should eq 10.0
	end

	it "solves problem 11" do
		lp = minimize(
			"sum(i in (0..3), j in (2..3), x[i] + 4x[j])",
		subject_to([
			"sum(i in (0..1), j in (0..3), 2x[i] - 3x[j]) >= 20",
			"forall(i in (0..3), j in (2..3), x[i] >= 0)"
		]))
		(lp.solution=={"x[0]"=>"10.0", "x[1]"=>"0.0", "x[2]"=>"0.0", "x[3]"=>"0.0"}).should eq true
		lp.objective.optimized_value.to_f.round(2).should eq 20.0
	end

	it "solves problem 12" do
		lp = maximize(
			"sum(i in (0..2), x[i])",
		subject_to([
			"forall(i in (0..2), x[i] <= 5)"
		]))
		lp.solution["x[0]"].to_f.round(2).should eq 5.0
		lp.solution["x[1]"].to_f.round(2).should eq 5.0
		lp.solution["x[2]"].to_f.round(2).should eq 5.0
		lp.objective.optimized_value.to_f.round(2).should eq 15.0
	end

	it "solves problem 13" do
		lp = minimize(
			"sum(i in (0..3), j in (0..3), x[i][j])",
		subject_to([
			"forall(i in (0..3), sum(j in (i..3), x[i][j]) >= i)",
			"forall(i in (0..3), sum(j in (0..i), x[i][j]) >= i)"
		]))
		(lp.solution=={"x[0][0]"=>"0.0", "x[0][1]"=>"0.0", "x[0][2]"=>"0.0", "x[0][3]"=>"0.0", "x[1][1]"=>"1.0", "x[1][2]"=>"0.0", "x[1][3]"=>"0.0", "x[2][2]"=>"2.0", "x[2][3]"=>"0.0", "x[3][3]"=>"3.0", "x[1][0]"=>"0.0", "x[2][0]"=>"0.0", "x[2][1]"=>"0.0", "x[3][0]"=>"0.0", "x[3][1]"=>"0.0", "x[3][2]"=>"0.0"}).should eq true
		lp.objective.optimized_value.to_f.round(2).should eq 6.0
	end

	it "solves problem 14" do
		lp = maximize(
			"x + 3",
		subject_to([
			"x + 9 <= 10"
		]))
		lp.solution["x"].to_f.round(2).should eq 1.0
		lp.objective.optimized_value.to_f.round(2).should eq 4.0
	end

	it "solves problem 15" do
		lp = maximize(
			"x + y - z",
		subject_to([
			"x = 5",
			"y < 3",
			"z > 4"
		]))
		lp.solution["x"].to_f.round(2).should eq 5.0
		lp.solution["y"].to_f.round(2).should eq 2.99
		lp.solution["z"].to_f.round(2).should eq 4.01
		lp.objective.optimized_value.to_f.round(2).should eq 3.98
	end

	it "solves problem 16" do
		lp = maximize(
			"x + y",
		subject_to([
			"x - 2.3 = 5.2",
			"3.2y <= 3",
		]))
		lp.solution["x"].to_f.round(2).should eq 7.5
		lp.solution["y"].to_f.round(2).should eq 0.94
		lp.objective.optimized_value.to_f.round(2).should eq 8.44
	end

	it "solves problem 17" do
		lp = maximize(
			"x",
		subject_to([
			"x >= 0",
			"x <= 100"
		],[
			"BOOLEAN: x"
		]
		))
		lp.solution["x"].to_f.round(2).should eq 1.0
		lp.objective.optimized_value.to_f.round(2).should eq 1.0
	end

	it "solves problem 18" do
		lp = maximize(
			"x",
		subject_to([
			"x <= 9.5"
		],[
			"INTEGER: x"
		]
		))
		lp.solution["x"].to_f.round(2).should eq 9.0
		lp.objective.optimized_value.to_f.round(2).should eq 9.0
	end

	it "solves problem 19" do
		lp = maximize(
			"10x1 + 6x2 + 4x3",
		subject_to([
			"x1 + x2 + x3 <= 100",
			"10x1 + 4x2 + 5x3 <= 600",
			"2x1 + 2x2 + 6x3 <= 300",
			"x1 >= 0",
			"x2 >= 0",
			"x3 >= 0"
		],[
			"BOOLEAN: x1",
			"INTEGER: x3"
		]
		))
		lp.solution["x1"].to_f.round(2).should eq 1.0
		lp.solution["x2"].to_f.round(2).should eq 99.0
		lp.solution["x3"].to_f.round(2).should eq 0.0
		lp.objective.optimized_value.to_f.round(2).should eq 604.0
	end

	it "solves problem 20" do
		lp = maximize(
			"x + y + x[3]",
		subject_to([
			"x <= 2.5",
			"x[3] <= 2.5",
			"x + x[3] <= 2.5",
			"y <= 4"
		],[
			"INTEGER: x, y",
		]
		))
		lp.solution["x"].to_f.round(2).should eq 2.0
		lp.solution["x[3]"].to_f.round(2).should eq 0.0
		lp.solution["y"].to_f.round(2).should eq 4.0
		lp.objective.optimized_value.to_f.round(2).should eq 6.0
	end

	it "solves problem 21" do
		lp = maximize(
			"x + y + z",
		subject_to([
			"x + z < 2",
			"y <= 4",
		],[
			"INTEGER: y",
			"EPSILON: 0.03"
		]
		))
		lp.solution["x"].to_f.round(2).should eq 1.97
		lp.solution["z"].to_f.round(2).should eq 0.0
		lp.solution["y"].to_f.round(2).should eq 4.0
		lp.objective.optimized_value.to_f.round(2).should eq 5.97
	end

	it "solves problem 22" do
		lp = maximize(
			"x",
		subject_to([
			"x <= -1"
		]))
		lp.solution["x"].to_f.round(2).should eq -1.0
		lp.objective.optimized_value.to_f.round(2).should eq -1.0
	end

	it "solves problem 23" do
		lp = maximize(
			"x + y + z",
		subject_to([
			"x = 5",
			"y = x",
			"z <= 2x"
		]))
		lp.solution["x"].to_f.round(2).should eq 5.0
		lp.solution["y"].to_f.round(2).should eq 5.0
		lp.solution["z"].to_f.round(2).should eq 10.0
		lp.objective.optimized_value.to_f.round(2).should eq 20.0
	end

	it "solves problem 24" do
		lp = maximize(
			"x + y + z + x[3]",
		subject_to([
			"x + y - z + x[3] + z +y <= z - x + y"
		],[
			"BOOLEAN: x, y, z"
		]))
		lp.solution["x"].to_f.round(2).should eq 0.0
		lp.solution["y"].to_f.round(2).should eq 0.0
		lp.solution["z"].to_f.round(2).should eq 1.0
		lp.solution["x[3]"].to_f.round(2).should eq 1.0
		lp.objective.optimized_value.to_f.round(2).should eq 2.0
	end

	it "solves problem 25" do
		lp = maximize(
			"10x1 + 6x2 + 4x3",
		subject_to([
			"x1 + x2 + x3 <= 100",
			"10x1 + 4x2 + 5x3 <= 600",
			"2x1 + 2x2 + 6x3 <= 300",
			"x[1] + x[3] <= 400"
		],[
			"NONNEGATIVE: x, x1, x2, x3"
		]
		))
		lp.solution["x1"].to_f.round(2).should eq 33.33
		lp.solution["x2"].to_f.round(2).should eq 66.67
		lp.solution["x3"].to_f.round(2).should eq 0.0
		lp.solution["x[1]"].to_f.round(2).should eq 0.0
		lp.solution["x[3]"].to_f.round(2).should eq 0.0
		lp.objective.optimized_value.to_f.round(2).should eq 733.33
	end

	it "solves problem 26" do
		lp = maximize(
			"10.3x[1] + 4.0005x[2] - x[3]",
		subject_to([
			"x[1] + 0.3x[2] - 1.5x[3] <= 100",
			"forall(i in (1..3), 1.3*x[i] <= 70)"
		],[
			"INTEGER: x"
		]
		))
		lp.solution["x[1]"].to_f.round(2).should eq 53.0
		lp.solution["x[2]"].to_f.round(2).should eq 53.0
		lp.solution["x[3]"].to_f.round(2).should eq -20.0
		lp.objective.optimized_value.to_f.round(2).should eq 777.93
	end

	it "solves problem 27" do
		lp = maximize(
			"o[0]x[0] + o[1]x[1] + o[2]x[2]",
		subject_to([
			"d[0]*x[0] + d[1]x[1] - d[2]*x[2] <= 100",
			"forall(i in (0..2), d[i]*x[i] <= 70)",
			"sum(i in (0..2), d[i]x[i]) <= 400"
		],[
			"INTEGER: x",
			"DATA: {d => [1, 0.3, 1.5], o => [10.3, 4.0005, -1]}"
		]
		))
		lp.solution["x[0]"].to_f.round(2).should eq 70.0
		lp.solution["x[1]"].to_f.round(2).should eq 233.0
		lp.solution["x[2]"].to_f.round(2).should eq 27.0
		lp.objective.optimized_value.to_f.round(2).should eq 1626.12
	end

	it "solves problem 28" do
		lp = maximize(
			"d*x",
		subject_to([
			"x <= d"
		],[
			"DATA: {d => 3}"
		]
		))
		lp.solution["x"].to_f.round(2).should eq 3.0
		lp.objective.optimized_value.to_f.round(2).should eq 9.0
	end

	it "solves problem 29" do
		lp = maximize(
			"o[0]x[0] + o[1]x[1] + o[2]x[2]",
		subject_to([
			"d[0]*x[0] + d[1]x[1] - d[2]*x[2] <= 100",
			"forall(i in (0..2), d[i]*x[i] <= 70)",
			"sum(i in (0..2), d[i]x[i]) <= 400",
			"forall(i in (0..2), sum(j in (0..i), d[i]x[i]) <= 1000)"
		],[
			"INTEGER: x",
			"DATA: {d => [1, 0.3, 1.5], o => [10.3, 4.0005, -1]}"
		]
		))
		lp.solution["x[0]"].to_f.round(2).should eq 70.0
		lp.solution["x[1]"].to_f.round(2).should eq 233.0
		lp.solution["x[2]"].to_f.round(2).should eq 27.0
		lp.objective.optimized_value.to_f.round(2).should eq 1626.12
	end

	it "solves problem 30" do
		lp = minimize(
			"d + a[0]x[0] + a[1]x[1]",
		subject_to([
			"a[0]x[0] - x[1] + 14 <= d",
		],[
			"NONNEGATIVE: a, x",
			"DATA: {a => [3.3, 4.7], d => 4}"
		]
		))
		lp.solution["x[0]"].to_f.round(2).should eq 0.0
		lp.solution["x[1]"].to_f.round(2).should eq 10.0
		lp.objective.optimized_value.to_f.round(2).should eq 51.0
	end

	it "solves problem 31" do
		lp = minimize(
			"d + sum(i in (0..1), a[i]x[i] + dx[i] - d)",
		subject_to([
			"a[0]x[0] - x[1] + 14 <= d",
		],[
			"NONNEGATIVE: a, x",
			"DATA: {a => [3.3, 4.7], d => 4}"
		]
		))
		lp.solution["x[0]"].to_f.round(2).should eq 0.0
		lp.solution["x[1]"].to_f.round(2).should eq 10.0
		lp.objective.optimized_value.to_f.round(2).should eq 83.0
	end

	it "solves problem 32" do
		lp = maximize(
			"sum(i in [1,2], j in (0..1), d[i][j+1]*x[i-1][j])",
		subject_to([
			"forall(i in (1..2), x[i-1][1] <= 100)",
			"forall(i in (0..2), j in (0..2), x[i][j] <= 200)"
		],[
			"NONNEGATIVE: x",
			"DATA: {d => [[3,5,3],[1,2,3],[2,5,9]]}"
		]
		))
		(lp.solution=={"x[0][1]"=>"100.0", "x[1][1]"=>"100.0", "x[0][0]"=>"200.0", "x[0][2]"=>"0.0", "x[1][0]"=>"200.0", "x[1][2]"=>"0.0", "x[2][0]"=>"0.0", "x[2][1]"=>"0.0", "x[2][2]"=>"0.0"}).should eq true
		lp.objective.optimized_value.to_f.round(2).should eq 2600.0
	end

	#multiple level data arrays with negatives and floats
	#arithmetic in indices in data arrays
	#arithmetic in indices in multiple level arrays
	#go ham on testing the interactions of data, sum, and forall
end
