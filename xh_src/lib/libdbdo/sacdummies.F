#if( defined(MachineA) || defined(Machinel) )
      subroutine newhdr()
      stop 'sac newhdr(): unsupported'
      end

      subroutine setnhv()
      stop 'sac setnhv(): unsupported'
      end

      subroutine setfhv()
      stop 'sac setfhv(): unsupported'
      end

      subroutine setihv()
      stop 'sac setihv(): unsupported'
      end

      subroutine setlhv()
      stop 'sac setlhv(): unsupported'
      end

      subroutine setkhv()
      stop 'sac setkhv(): unsupported'
      end

      subroutine wsac0()
      stop 'sac wsac0(): unsupported'
      end
#else
      subroutine sacdummies()
      end
#endif

