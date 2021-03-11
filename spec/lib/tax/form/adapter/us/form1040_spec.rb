# require_relative "../../../../../spec_helper.rb"

# describe PiggyBank::Tax::Form::Adapter::US::Form1040 do
#   context "new instance" do

#     before(:example) do
#       f8863 = PiggyBank::Tax::Form::Adapter::US::Form8863.instance
#       sched3 = PiggyBank::Tax::Form::Adapter::US::Schedule3.instance
#       @form = PiggyBank::Tax::Form::Adapter::US::Form1040.instance
#       sched3.us_1040 = @form
#       sched3.us_8863 = f8863
#       f8863.us_sched3 = sched3
#     end
    
#     it "calculates line 1, total wages" do
#       expect(@form.line_1).to eq 117921
#     end

#     it "calculates tax amounts" do 
#       expect(@form.get_tax_amount(_d("78901.0"), :joint)).to eq 9076
#       expect(@form.get_tax_amount(_d("61049.0"), :single)).to eq 9216
#       expect(@form.get_tax_amount(_d("123456.0"), :single)).to eq 23709
#       expect(@form.get_tax_amount(_d("666666.0"), :hoh)).to eq 209652
#       expect(@form.get_tax_amount(_d("666666.0"), :separate)).to eq 215241
#     end
#   end
# end
