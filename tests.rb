require "rspec"
require "./lib/lpsolve"

describe "lpsolve" do
	before :all do
	end

	before :each do
	end

	it "solves problem 1" do
		lp = maximize(
			"10x1 + 6x2 + 4x3",
		subject_to([
			"p: x1 + x2 + x3 <= 100",
			"q: 10x1 + 4x2 + 5x3 <= 600",
			"r: 2x1 + 2x2 + 6x3 <= 300",
			"s: x1 >= 0",
			"t: x2 >= 0",
			"u: x3 >= 0"
		]))
		lp.solution["x1"].to_f.round(2).should eq 33.33
		lp.solution["x2"].to_f.round(2).should eq 66.67
		lp.solution["x3"].to_f.round(2).should eq 0.0
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
	end

	it "solves problem 3" do
		lp = minimize(
			"a - x4",
		subject_to([
			"a + x4 >= 4",
			"a + x4 <= 10"
		]))
		lp.solution["a"].to_f.round(2).should eq 0.0
		lp.solution["x4"].to_f.round(2).should eq 10.0
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
	end

	it "solves problem 9" do
		lp = minimize(
			"sum(i in (0..1), j in [0,1], x[i][j])",
		subject_to([
			"sum(i in (0..1), j in [0,1], x[i][j]) >= 10"
		]))
		(lp.solution=={"x[0][0]"=>"10.0", "x[0][1]"=>"0.0", "x[1][0]"=>"0.0", "x[1][1]"=>"0.0"}).should eq true
	end

	it "solves problem 10" do
		lp = minimize(
			"sum(i in (0..3), x[i])",
		subject_to([
			"sum(i in (0..1), x[i]) + sum(i in [2,3], 2x[i]) >= 20"
		]))
		(lp.solution=={"x[0]"=>"0.0", "x[1]"=>"0.0", "x[2]"=>"10.0", "x[3]"=>"0.0"}).should eq true
	end

	it "solves problem 11" do
		lp = minimize(
			"sum(i in (0..3), j in (2..3), x[i] + 4x[j])",
		subject_to([
			"sum(i in (0..1), j in (0..3), 2x[i] - 3x[j]) >= 20"
		]))
		(lp.solution=={"x[0]"=>"10.0", "x[1]"=>"0.0", "x[2]"=>"0.0", "x[3]"=>"0.0"}).should eq true
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
	end

	#forall(i in [0..3], sum(j in (i..5), x[j][i]) => i)

	#have one here that has a constant in it
end
