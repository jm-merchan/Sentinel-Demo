
mock "tfconfig/v2" {
  module {
    source = "mocks/mock-tfconfig-v2.sentinel"
  }
}

mock "tfplan/v2" {
  module {
    source = "mocks/mock-tfplan-v2.sentinel"
  }
}


mock "tfstate/v2" {
  module {
    source = "mocks/mock-tfstate-v2.sentinel"
  }
}

mock "tfrun" {
  module {
    source = "mocks/mock-tfrun.sentinel"
  }
}
