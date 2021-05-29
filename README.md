# Over-complete Dictionary

Signals are often represented as a linear combination of basis functions (like Fourier, Cosine or Wavelet representations).  
The basis functions always have the same dimensionality as the (discrete) signals they represent.  
The number of basis functions is traditionally the same as the dimensionality of the signals they represent.  
A more general representation for signals uses so called “over-complete dictionaries”, where the number of basis functions is **more** than the dimensionality of the signals.

With complete bases, the representation of the signal is always **unique**.  
This uniqueness is **lost** with over-complete basis.  
Since a signal can have many representations in an over-complete basis, we pick the **sparsest** one  
Over-complete bases afford much greater compactness in signal representation.
