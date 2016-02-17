## Phases ##

  1. Integrate single look functions first (sgnl)
  1. Integrate T3 and C3 types

## Matlab data representation ##

Structure with the following fields
  * data: matrix with dimension nrows x ncols x nbands
  * info: contains metadata information:
    * type: data type (T3, C3, FREEMAN, etc.)
    * Nlooks: number of looks
    * history: cells containing processing applied if any
    * others?