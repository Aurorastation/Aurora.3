describe('It opens', function () {
  it('works', function () {

    cy.fixture('vote.json').then((json) => {
      console.log(json)
      cy.loadInitialState(JSON.stringify(json))
    })
  })
})