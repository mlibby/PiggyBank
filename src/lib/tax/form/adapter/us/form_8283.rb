require_relative "../base"

class PiggyBank::Tax::Form::Adapter::US::Form8283 < PiggyBank::Tax::Form::Adapter::Base
  def initialize(noncash)
    @noncash = noncash
    super()
  end
  
  def line_Aa
    @noncash[0]&.charity + "\n" + @noncash[0]&.address
  end

  def line_Ac
    @noncash[0]&.description
  end

  def line_Ad
    @noncash[0]&.date
  end

  def line_Ah
    _d(@noncash[0]&.amount)
  end

  def line_Ai
    @noncash[0]&.method
  end

  def line_Ba
    @noncash[1]&.charity + "\n" + @noncash[1]&.address
  end

  def line_Bc
    @noncash[1]&.description
  end

  def line_Bd
    @noncash[1]&.date
  end

  def line_Bh
    _d(@noncash[1]&.amount)
  end

  def line_Bi
    @noncash[1]&.method
  end

  def line_Ca
    @noncash[2]&.charity + "\n" + @noncash[2]&.address
  end

  def line_Cc
    @noncash[2]&.description
  end

  def line_Cd
    @noncash[2]&.date
  end

  def line_Ch
    _d(@noncash[2]&.amount)
  end

  def line_Ci
    @noncash[2]&.method
  end

  def line_Da
    @noncash[3]&.charity + "\n" + @noncash[3]&.address
  end

  def line_Dc
    @noncash[3]&.description
  end

  def line_Dd
    @noncash[3]&.date
  end

  def line_Dh
    _d(@noncash[3]&.amount)
  end

  def line_Di
    @noncash[3]&.method
  end

  def line_Ea
    @noncash[4]&.charity + "\n" + @noncash[4]&.address
  end

  def line_Ec
    @noncash[4]&.description
  end

  def line_Ed
    @noncash[4]&.date
  end

  def line_Eh
    _d(@noncash[4]&.amount)
  end

  def line_Ei
    @noncash[4]&.method
  end
end
