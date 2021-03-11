def seed_blobs
  general_yaml =
    <<~YAML
      ---
      :filing_status: joint
      :virtual: false
      :first_name: George 
      :last_name: McFly
      :ssn: '123-45-6789'
      :birthday: '1955-07-04'
      :blind: true
      :campaign: true
      :spouse_first_name: Lorraine
      :spouse_last_name: Baines-McFly
      :spouse_ssn: '987-65-4321'
      :spouse_birthday: '1956-05-04'
      :spouse_blind: false
      :spouse_campaign: false
      :street: 9303 Lyon Drive
      :apt_no: '1985'
      :city: Hill Valley
      :state: CA
      :zip: '95420'
      :country: ''
      :province: ''
      :post_code: ''
      :mn_campaign: "15"
      :spouse_mn_campaign: "16"
      :dependents:
      - !ruby/object:PiggyBank::Tax::Data::Dependent
        first_name: Dave
        last_name: McFly
        ssn: '555445555'
        relation: Child
        child_credit: true
        other_credit: false
      - !ruby/object:PiggyBank::Tax::Data::Dependent
        first_name: Linda
        last_name: McFly
        ssn: '111221111'
        relation: Child
        child_credit: true
        other_credit: false
      - !ruby/object:PiggyBank::Tax::Data::Dependent
        first_name: Marty
        last_name: McFly
        ssn: '101010101'
        relation: Child
        child_credit: true
        other_credit: false
      - !ruby/object:PiggyBank::Tax::Data::Dependent
        first_name: Emmett
        last_name: Brown
        ssn: '909090909'
        relation: Uncle
        child_credit: false
        other_credit: true
      - !ruby/object:PiggyBank::Tax::Data::Dependent
        first_name: Einstein
        last_name: Brown
        ssn: '010101010'
        relation: Pet Dog
        child_credit: false
        other_credit: false
    YAML

  deduct_yaml =
    <<~YAML
      ---
      :real_estate_tax: '9205'
      :property_tax: '256'
      :form1098s:
      - !ruby/object:PiggyBank::Tax::Data::Form1098
        interest: '4321.99'
        outstanding: '123456.78'
        origination: '2016-02-02'
        refund: ''
        premiums: ''
        points_paid: ''
        same_address: 
        address: ''
        properties: '1'
        other: ''
        acquisition: '2018-09-09'
      :cash_donations:
      - !ruby/object:PiggyBank::Tax::Data::CashDonation
        charity: ACLU
        amount: '256'
      - !ruby/object:PiggyBank::Tax::Data::CashDonation
        charity: Doctors without Borders
        amount: '23456'
      :noncash_donations:
      - !ruby/object:PiggyBank::Tax::Data::NonCashDonation
        charity: Goodwill
        address: 555 Secondhand Street
        description: Clothes, Games
        date: '2020-02-01'
        amount: '414'
        method: comparable prices
      - !ruby/object:PiggyBank::Tax::Data::NonCashDonation
        charity: Sortawill
        address: 511 Thirdhand Street
        description: Kitchenware
        date: '2020-04-01'
        amount: '113'
        method: guessing
      - !ruby/object:PiggyBank::Tax::Data::NonCashDonation
        charity: Badwill
        address: 987 Tossout Blvd
        description: Clutter
        date: '2020-06-11'
        amount: '227'
        method: looking/shrugging
      - !ruby/object:PiggyBank::Tax::Data::NonCashDonation
        charity: Neutralwill
        address: 7881 Washington Circle
        description: Books
        date: '2020-09-09'
        amount: '332'
        method: comparable items
      - !ruby/object:PiggyBank::Tax::Data::NonCashDonation
        charity: Stuff for People
        address: 999 123nd Ave SE
        description: Home Decor
        date: '2020-10-31'
        amount: '112'
        method: Fibonacci sequence 
      - !ruby/object:PiggyBank::Tax::Data::NonCashDonation
        charity: People w/o Stuff
        address: 1 Two Street
        description: Blankets
        date: '2020-12-25'
        amount: '33'
        method: rolling dice
    YAML

  income_yaml =
    <<~YAML
      ---
      :state_refund: '123.45'
      :other_credits: '0.00'
      :other_credits: '0.00'
      :rentals:
      - !ruby/object:PiggyBank::Tax::Data::Rental
        physical_address: 3793 Oakhurst Street, Hilldale, CA 91732
        property_type: '3'
        fair_rental_days: '365'
        personal_days: '0'
        qualified_joint_venture: 
        rents_received: '1024'
        royalties_received: ''
        advertising: ''
        auto: ''
        cleaning: ''
        commissions: ''
        insurance: ''
        legal_fees: ''
        management_fees: '256'
        mortgage_interest: ''
        other_interest: ''
        repairs: ''
        supplies: ''
        taxes: '128'
        utilities: ''
        depreciation: ''
        other_desc: ''
        other_amount: ''
      :w2s:
      - !ruby/object:PiggyBank::Tax::Data::W2
        ssn: '123-45-6789'
        ein: '00-0000011'
        employer: Hill Valley College
        wages: '28921'
        fed_wh: '1210'
        soc_sec_wages: '28921'
        soc_sec_wh: '1793'
        medicare_wages: '28921'
        medicare_taxes: '419'
        soc_sec_tips: ''
        allocated_tips: ''
        box_9: 
        dep_care_benefits: ''
        nonqual_plans: ''
        code_12a: ''
        box_12a: ''
        code_12b: ''
        box_12b: ''
        code_12c: ''
        box_12c: ''
        code_12d: ''
        box_12d: ''
        statutory_employee: true
        retirement_plan: false
        sick_pay: false
        other: ''
        state: 'CA'
        state_ein: '00-0000056'
        state_wages: '28921'
        state_tax: '851'
        local_wages: ''
        local_tax: ''
        locality: ''
      - !ruby/object:PiggyBank::Tax::Data::W2
        ssn: '987-65-4321'
        ein: '00-0000012'
        employer: Flux Corporation
        wages: '89000'
        fed_wh: '13000'
        soc_sec_wages: '89000'
        soc_sec_wh: '7130'
        medicare_wages: '89000'
        medicare_taxes: '1668'
        soc_sec_tips: ''
        allocated_tips: ''
        box_9: 
        dep_care_benefits: ''
        nonqual_plans: ''
        code_12a: ''
        box_12a: ''
        code_12b: ''
        box_12b: ''
        code_12c: ''
        box_12c: ''
        code_12d: ''
        box_12d: ''
        statutory_employee: false
        retirement_plan: false
        sick_pay: false
        other: ''
        state: 'CA'
        state_ein: '00-0000057'
        state_wages: '89000'
        state_tax: '2200'
        local_wages: ''
        local_tax: ''
        locality: ''
      :f1099_ints:
      - !ruby/object:PiggyBank::Tax::Data::Form1099Int
        payer: Internal Revenue Service
        payer_id: 38-1798424
        paid: '76.54'        
      :f1099_divs:
      - !ruby/object:PiggyBank::Tax::Data::Form1099Div
        payer: ACME Chemical
        payer_id: 99-1233456
        account_number: '12983476'
        ordinary_dividends: '77.77'
        qualified_dividends: '77.77'        
      YAML

    education_yaml = 
      <<~YAML
        ---
        :student_name: Lorraine Baines-McFly
        :student_ssn: '987-65-4321    '
        :institution_name: Future College
        :institution_address: 123 University Ave, Hill Valley, CA 90210
        :institution_ein: 99-8765432
        :lifetime_credit_expenses: '5678'
        :received_1098: true
        :box_7_checked: true
        :hope_opportunity_claimed: false
        :at_least_half_time: true
        :postsecondary_completed: true
      YAML

  PiggyBank::Blob.create name: "2020-tax-general",
                         yaml: general_yaml

  PiggyBank::Blob.create name: "2020-tax-income",
                         yaml: income_yaml

  PiggyBank::Blob.create name: "2020-tax-deduct",
                         yaml: deduct_yaml

  PiggyBank::Blob.create name: "2020-tax-education",
                         yaml: education_yaml

end
