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
      :dependents:
      - !ruby/object:PiggyBank::Tax::Data::Dependent
        name: Dave McFly
        ssn: '555445555'
        relation: Child
        child_credit: true
        other_credit: false
      - !ruby/object:PiggyBank::Tax::Data::Dependent
        name: Linda McFly
        ssn: '111221111'
        relation: Child
        child_credit: true
        other_credit: false
      - !ruby/object:PiggyBank::Tax::Data::Dependent
        name: Marty McFly
        ssn: '101010101'
        relation: Child
        child_credit: true
        other_credit: false
      - !ruby/object:PiggyBank::Tax::Data::Dependent
        name: Emmett Brown
        ssn: '909090909'
        relation: Uncle
        child_credit: false
        other_credit: true
      - !ruby/object:PiggyBank::Tax::Data::Dependent
        name: Einstein Brown
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
        wages: '115000'
        fed_wh: '23000'
        soc_sec_wages: '115000'
        soc_sec_wh: '7130'
        medicare_wages: '115000'
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
        state_wages: '115000'
        state_tax: '3200'
        local_wages: ''
        local_tax: ''
        locality: ''
    YAML

  PiggyBank::Blob.create name: "2020-tax-general",
                         yaml: general_yaml

  PiggyBank::Blob.create name: "2020-tax-income",
                         yaml: income_yaml

  PiggyBank::Blob.create name: "2020-tax-deduct",
                         yaml: deduct_yaml
end
