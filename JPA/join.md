# N:1 mapping
  
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "${현재 entity column}", referencedColumnName = "${N 맵핑 entity column}, insertable = "false", updatable = "false")
    private ${entity}